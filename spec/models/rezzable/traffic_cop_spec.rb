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

  it { should have_many(:visits).class_name('Analyzable::Visit').dependent(:nullify) }

  it {
    should define_enum_for(:sensor_mode).with_values(
      sensor_mode_region: 0,
      sensor_mode_parcel: 1,
      sensor_mode_owned_parcels: 2
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
      access_mode_banned: 0,
      access_mode_allowed: 1
    )
  }

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
