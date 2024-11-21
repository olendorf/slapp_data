# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Analyzable::Visit, type: :model do
  let(:visit) { FactoryBot.create :visit }

  it { should belong_to(:user).optional(true) }
  it { should belong_to(:traffic_cop).optional(true) }
  it { should have_many(:detections) }
  
  # it 'should cover ransackable_attributes method ' do
  #   expect(subject.class.ransackable_attributes).to include('id', 'id_value')
  # end

  it 'should cover ransackable_associations method ' do
    expect(subject.class.ransackable_associations)
      .to include('detections', 'user', 'traffic_cop')
  end
  
  it 'should cover ransackable_attributes method ' do
    expect(subject.class.ransackable_attributes)
          .to include('avatar_key',  'avatar_name', 'created_at', 'duration', 
                      'id', 'id_value', 'region', 'traffic_cop_id', 'updated_at',
                      'user_id')
  end


  describe '#active?' do
    context 'visit is active' do
      it 'should return true' do
        visit.detections << FactoryBot.create(:detection, created_at: 1.minute.ago)
        expect(visit.active?).to be_truthy
      end
    end

    context 'visit is inactive' do
      it 'should return false' do
        visit.detections << FactoryBot.create(:detection, created_at: 5.minutes.ago)
        expect(visit.active?).to be_falsey
      end
    end
  end

  describe 'adding a detection' do
    let(:detection) { FactoryBot.create :detection }
    let(:visit) { FactoryBot.create :visit }
    context 'first detection' do
      it 'should set the avatar name' do
        visit.detections << detection
        expect(visit.avatar_name).to eq detection.avatar_name
      end

      it 'should set the avatar key' do
        visit.detections << detection
        expect(visit.avatar_key).to eq detection.avatar_key
      end

      it 'should update the duration' do
        visit.detections << detection
        expect(visit.duration).to eq 0
      end
    end

    context 'not the first detection' do
      it 'should update the duration' do
        visit
        4.times do |i|
          new_detection = FactoryBot.create :detection, created_at: (i * 30).seconds.from_now
          visit.detections << new_detection
        end
        expect(visit.duration).to be_within(2).of(90)
      end
    end
  end
end
