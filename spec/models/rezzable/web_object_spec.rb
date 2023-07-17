# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rezzable::WebObject do
  let(:web_object) do
    web_object = build(:web_object)
    web_object.save
    web_object
  end

  it { is_expected.to act_as AbstractWebObject }

  describe '#settings' do
    it 'returns the correct settings' do
      expect(web_object.settings).to include(
        'object_name' => web_object.object_name,
        'object_key' => web_object.object_key,
        'description' => web_object.description,
        'region' => web_object.region,
        'position' => web_object.position,
        'url' => web_object.url,
        'api_key' => web_object.api_key,
        'major_version' => web_object.major_version,
        'minor_version' => web_object.minor_version,
        'patch_version' => web_object.patch_version,
        'server_id' => web_object.server_id,
        'setting_one' => web_object.setting_one,
        'setting_two' => web_object.setting_two
      )
    end
  end
end
