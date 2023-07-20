# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rezzable::WebObject do
  let(:web_object) do
    web_object = build(:web_object)
    web_object.save
    web_object
  end

  it { is_expected.to act_as AbstractWebObject }
  
  describe '#response_data' do 
    it 'should return the correct data' do 
      expect(web_object.response_data).to include(
        api_key: web_object.api_key,
        object_name: web_object.object_name,
        description: web_object.description,
        setting_one: web_object.setting_one,
        setting_two: web_object.setting_two
        )
    end
  end
  
  describe '#reset_to_defaults!' do 
    it 'should reset the object to default values' do
      web_object.reset_to_defaults!
      expect(web_object.setting_one).to eq "default"
    end
  end
end
