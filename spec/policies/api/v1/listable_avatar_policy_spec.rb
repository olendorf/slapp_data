require 'rails_helper'

RSpec.describe Api::V1::ListableAvatarPolicy, type: :policy do  
  
  let(:active_user) { FactoryBot.create :user, expiration_date: 1.day.from_now }
  let(:active_object) do
    active_object = FactoryBot.build :traffic_cop
    active_user.web_objects << active_object
    active_object
  end

  subject { described_class }


  permissions :index? do
    it 'should permit an active user' do 
      expect(subject).to permit(active_user, active_object)
    end
  end

  permissions :create? do
    it 'should not permit an active user' do 
      expect(subject).to_not permit(active_user, active_object)
    end
  end

end
