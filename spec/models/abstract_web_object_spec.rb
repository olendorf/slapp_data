# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AbstractWebObject do
  it { is_expected.to respond_to :api_key }

  it { is_expected.to validate_presence_of :object_name }
  it { is_expected.to validate_presence_of :object_key }
  it { is_expected.to validate_presence_of :region }
  it { is_expected.to validate_presence_of :position }
  it { is_expected.to validate_presence_of :url }

  it { is_expected.to be_actable }

  it { is_expected.to belong_to(:user).optional(true) }
  
  let(:web_object) do
    web_object = FactoryBot.build :abstract_web_object
    web_object.save
    web_object
  end  
  
  describe "initialization" do 
    it 'should set the api_key' do
      expect(web_object.api_key).to_not be_nil
    end
    
    it 'should set the pinged_at' do 
      expect(web_object.pinged_at).to be_within(1.second).of(Time.current)
    end
  end

  describe '#response_data' do 
    it 'should return the correct data' do 
      expect(web_object.response_data).to include(
        api_key: web_object.api_key,
        object_name: web_object.object_name,
        description: web_object.description
        )
    end
  end
  
  describe 'active?' do
    it 'returns true when object has been pinged recently' do
      expect(web_object.active?).to be_truthy
    end

    it 'returns false when the object has not been pinged recently' do
      web_object.pinged_at = 1.hour.ago
      expect(web_object.active?).to be_falsey
    end
  end
end
