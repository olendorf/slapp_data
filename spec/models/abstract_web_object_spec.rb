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

  it {
    should belong_to(:server)
      .class_name('Rezzable::Server')
      .required(false)
      .touch(true)
  }

  it { should have_many(:transactions).class_name('Analyzable::Transaction').dependent(:nullify) }

  it 'should set the api_key upon creation' do
    expect(web_object.api_key).to_not be_nil
  end
end
