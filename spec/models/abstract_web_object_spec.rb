# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AbstractWebObject, type: :model do
  let(:web_object) { FactoryBot.build :abstract_web_object }

  it { expect(AbstractWebObject).to be_actable }
  it {
    should belong_to(:user)
      .touch(true)
      .required(false)
  }
  

  it 'should set the api_key upon creation' do
    expect(web_object.api_key).to_not be_nil
  end
end
