# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Rezzable::WebObject, type: :model do
  it_behaves_like 'a rezzable object', :web_object, 100
  let(:user) { FactoryBot.create :user }
  let(:web_object) do
    web_object = FactoryBot.build :web_object, user_id: user.id
    web_object.save
    web_object
  end
  it { expect(Rezzable::WebObject).to act_as(AbstractWebObject) }

  it 'should cover ransackable_associations method ' do
    expect(subject.class.ransackable_associations)
      .to include('abstract_web_object', 'actable', 'user', 'created_at')
  end

  it 'should cover ransackable_attributes method ' do
    expect(subject.class.ransackable_attributes)
      .to include('id', 'id_value')
  end

  describe '.response_data' do
    it 'should return the correct data' do
      expect(web_object.response_data).to include(
        api_key: web_object.api_key,
        object_name: web_object.object_name,
        description: web_object.description
      )
    end
  end
end
