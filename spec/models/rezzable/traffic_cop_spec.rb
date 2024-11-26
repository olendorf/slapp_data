# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rezzable::TrafficCop, type: :model do
  let(:user) { FactoryBot.create :user }

  it { should have_many(:listable_avatars).dependent(:destroy) }

  let(:server) do
    server = FactoryBot.build :server
    user.web_objects << server
    server
  end

  let(:traffic_cop) do
    traffic_cop = FactoryBot.build :traffic_cop, server_id: server.id
    user.web_objects << traffic_cop
    traffic_cop
  end

  it_behaves_like 'a rezzable object', :traffic_cop, 25

  it { expect(Rezzable::Server).to act_as(AbstractWebObject) }

  it 'should cover ransackable_associations method ' do
    expect(subject.class.ransackable_associations)
      .to include('abstract_web_object', 'actable', 'user', 'created_at')
  end

  it 'should cover ransackable_attributes method ' do
    expect(subject.class.ransackable_attributes)
      .to include('id', 'id_value')
  end

  it { should have_many(:visits).class_name('Analyzable::Visit').dependent(:nullify) }

  it {
    should define_enum_for(:sensor_mode).with_values(
      sensor_mode_region: 0,
      sensor_mode_parcel: 1,
      sensor_mode_owned: 2
    )
  }

  it {
    should define_enum_for(:security_mode).with_values(
      security_mode_off: 0,
      security_mode_parcel: 1,
      security_mode_owned_parcels: 2
    )
  }

  it {
    should define_enum_for(:access_mode).with_values(
      access_mode_anyone: 0,
      access_mode_banned: 1,
      access_mode_allowed: 2
    )
  }

  it {
    should define_enum_for(:power).with_values(
      power_off: 0,
      power_on: 1
    )
  }

  describe '#current_visitors' do
    before(:each) do
      traffic_cop.visits << FactoryBot.build(:visit, created_at: 2.hours.ago,
                                                     updated_at: 2.hours.ago)

      traffic_cop.visits << FactoryBot.build(:visit, created_at: 1.hours.ago,
                                                     updated_at: 1.minute.ago)

      traffic_cop.visits << FactoryBot.build(:visit, created_at: 1.hours.ago,
                                                     updated_at: 1.minute.ago)
    end

    it 'should return only the current visitors' do
      expect(traffic_cop.current_visitors.size).to eq 2
    end
  end

  describe '#visitors' do
    before(:each) do
      traffic_cop.visits << FactoryBot.build(:visit, created_at: 2.hours.ago,
                                                     updated_at: 1.hour.ago,
                                                     duration: 1.hour)

      traffic_cop.visits << FactoryBot.build(:visit, avatar_name: 'foo',
                                                     avatar_key: 'bar',
                                                     created_at: 1.hours.ago,
                                                     updated_at: 15.seconds.ago,
                                                     duration: 1.hour - 15.seconds)

      traffic_cop.visits << FactoryBot.build(:visit, avatar_name: 'foo',
                                                     avatar_key: 'bar',
                                                     created_at: 1.hours.ago,
                                                     updated_at: 30.seconds.ago,
                                                     duration: 1.hour - 30.seconds)
    end
    it 'should return the summed time spent by each avatar' do
      expect(traffic_cop.visitors.size).to eq 2
    end
  end

  describe 'detections' do
    let(:detections) { FactoryBot.attributes_for_list :detection, 10 }
    context 'there are no visits' do
      it 'should create visits' do
        expect do
          traffic_cop.update(detections:)
        end.to change(traffic_cop.visits, :count).by(10)
      end

      it 'should set the visit region' do
        traffic_cop.update(detections:)
        expect(traffic_cop.visits.last.region).to eq traffic_cop.region
      end
    end

    context 'its detection from the same visit' do
      before(:each) do
        traffic_cop.update(detections: FactoryBot.attributes_for_list(:detection, 3))
      end
      let(:detections) do
        last_visit = traffic_cop.visits.last
        [
          FactoryBot.attributes_for(
            :detection,
            avatar_name: last_visit.avatar_name,
            avatar_key: last_visit.avatar_key,
            created_at: 1.minutes.ago
          )
        ]
      end
      it 'should not create any new visits' do
        expect do
          traffic_cop.update(detections:)
        end.to_not change(traffic_cop.visits, :count)
      end
    end

    context 'the detection is from a repeat visitor but a new visit' do
      before(:each) do
        detections = FactoryBot.attributes_for_list(:detection, 3, created_at: 5.minutes.ago)
        traffic_cop.update(detections:)
      end
      let(:detections) do
        last_visit = traffic_cop.visits.last
        [
          FactoryBot.attributes_for(
            :detection,
            avatar_name: last_visit.avatar_name,
            avatar_key: last_visit.avatar_key
          )
        ]
      end
      it 'should  create a new visits' do
        expect do
          traffic_cop.update(detections:)
        end.to change(traffic_cop.visits, :count).by(1)
      end
    end

    describe 'response data' do
      let(:old_detections) do
        FactoryBot.attributes_for_list :detection, 2, created_at: 1.hour.ago
      end
      before(:each) do
        traffic_cop.update detections: old_detections
      end
      let(:detections) { FactoryBot.attributes_for_list :detection, 2 }
      context 'avatars first visit' do
        it 'should set the correct keys' do
          traffic_cop.update detections: detections + old_detections
          expect(traffic_cop.outgoing_messages[:first_visit])
            .to eq(detections.collect { |d| d[:avatar_key] })
        end
      end

      context 'avatar has not visited recently' do
        let(:avatars) { FactoryBot.create_list :avatar, 1 }

        it ' should set the correct keys' do
          avies = avatars
          stale_detections = FactoryBot.attributes_for_list(:detection, 1) do |detection, i|
            detection[:avatar_name] = avies[i].avatar_name
            detection[:avatar_key] = avies[i].avatar_key
          end

          traffic_cop.update detections: stale_detections
          visit = traffic_cop.visits.last
          visit.created_at = 3.weeks.ago
          visit.save
          traffic_cop.reload
          repeat_detections = FactoryBot.attributes_for_list(:detection,
                                                             1) do |detection, i|
            detection[:avatar_name] = avies[i].avatar_name
            detection[:avatar_key] = avies[i].avatar_key
          end

          traffic_cop.update detections: repeat_detections
          expect(traffic_cop.outgoing_messages[:repeat_visit])
            .to eq(avatars.collect(&:avatar_key))
        end
      end

      context 'traffic cop is in access list only mode' do
        let(:allowed) { FactoryBot.build_list :allowed_avatar, 2 }
        let(:detections) do
          detections = FactoryBot.attributes_for_list :detection, 3
          allowed.each do |avatar|
            detections += FactoryBot.attributes_for_list :detection, 1,
                                                         avatar_name: avatar.avatar_name,
                                                         avatar_key: avatar.avatar_key
          end
          detections
        end
        before(:each) do
          traffic_cop.update(access_mode: :access_mode_allowed)
          traffic_cop.save
          traffic_cop.listable_avatars << allowed
        end
        it 'should only allow the allowed detections ' do
          traffic_cop.update(detections:)
          expect(traffic_cop.outgoing_messages[:first_visit]).to eq(allowed.collect(&:avatar_key))
        end

        it 'should eject others' do
          traffic_cop.update(detections:)
          expected = detections.collect { |a| a[:avatar_key] } - allowed.collect do |a|
                                                                   a[:avatar_key]
                                                                 end
          expect(traffic_cop.outgoing_messages[:eject]).to eq expected
        end
      end

      context 'traffic cop is in banned mode' do
        let(:banned) { FactoryBot.build_list :banned_avatar, 2 }
        let(:detections) do
          detections = FactoryBot.attributes_for_list :detection, 3
          banned.each do |avatar|
            detections += FactoryBot.attributes_for_list :detection, 1,
                                                         avatar_name: avatar.avatar_name,
                                                         avatar_key: avatar.avatar_key
          end
          detections
        end
        before(:each) do
          traffic_cop.update(access_mode: :access_mode_banned)
          traffic_cop.save
          traffic_cop.listable_avatars << banned
        end
        it 'should only allow the non-banned detections ' do
          traffic_cop.update(detections:)
          expected = detections.collect { |a| a[:avatar_key] } - banned.collect do |b|
                                                                   b[:avatar_key]
                                                                 end
          expect(traffic_cop.outgoing_messages[:first_visit]).to eq expected
        end

        it 'should eject others' do
          traffic_cop.update(detections:)
          expect(traffic_cop.outgoing_messages[:eject]).to eq(banned.collect(&:avatar_key))
        end
      end
    end
  end

  describe '#add_to_allowed_list' do
    it 'should add the listable ' do
      avatar = FactoryBot.build(:avatar)
      traffic_cop.add_to_allowed_list(avatar.avatar_name, avatar.avatar_key)
      expect(traffic_cop.listable_avatars.where(list_name: 'allowed').size).to eq 1
    end
  end

  describe '#add_to_banned_list' do
    it 'should add the listable' do
      avatar = FactoryBot.build(:avatar)
      traffic_cop.add_to_banned_list(avatar.avatar_name, avatar.avatar_key)
      expect(traffic_cop.listable_avatars.where(list_name: 'banned').size).to eq 1
    end
  end

  describe '#allowed_list' do
    it 'should return only allowed avatars' do
      traffic_cop.listable_avatars << FactoryBot.build(:allowed_avatar)
      traffic_cop.listable_avatars << FactoryBot.build(:allowed_avatar)
      traffic_cop.listable_avatars << FactoryBot.build(:allowed_avatar)
      traffic_cop.listable_avatars << FactoryBot.build(:banned_avatar)
      traffic_cop.listable_avatars << FactoryBot.build(:banned_avatar)
      expect(traffic_cop.allowed_list.size).to eq 3
    end
  end

  describe '#banned_list' do
    it 'should return only banned avatars' do
      traffic_cop.listable_avatars << FactoryBot.build(:allowed_avatar)
      traffic_cop.listable_avatars << FactoryBot.build(:allowed_avatar)
      traffic_cop.listable_avatars << FactoryBot.build(:allowed_avatar)
      traffic_cop.listable_avatars << FactoryBot.build(:banned_avatar)
      traffic_cop.listable_avatars << FactoryBot.build(:banned_avatar)
      expect(traffic_cop.banned_list.size).to eq 2
    end
  end
end
