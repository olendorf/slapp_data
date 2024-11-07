# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AbstractWebObject, type: :model do
  let(:user) { FactoryBot.create :user }
  let(:web_object) do 
    web_object = FactoryBot.build :web_object 
    user.web_objects << web_object
    web_object
  end

  it { expect(AbstractWebObject).to be_actable }
  it {
    should belong_to(:user)
      .touch(true)
      .required(false)
  }
  
  it {
    should belong_to(:inventory).class_name('Analyzable::Inventory').required(false)
  }

  it {
    should belong_to(:server)
      .class_name('Rezzable::Server')
      .required(false)
      .touch(true)
  }

  it { should have_many(:transactions).class_name('Analyzable::Transaction').dependent(:nullify) }

  it { should have_many(:splits).dependent(:destroy) }

  it 'should set the api_key upon creation' do
    expect(web_object.api_key).to_not be_nil
  end
  
end
