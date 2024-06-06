require 'rails_helper'

RSpec.describe Api::V1::Rezzable::WebObjectPolicy, type: :policy do
  let(:activer_user) { FactoryBot.create :user, expiration_date: 1.day.from_now }
  let(:active_object) { FactoryBot.create :web_object,  user_id: active_user.id }
  
  let(:inactive_user) { FactoryBot.create :user, expiration_date: 1.day.ago }
  let(:inactive_object) { FactoryBot.create :web_object, user_id: inactive_user.id }

  subject { described_class }

  permissions :show? do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  permissions :create? do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  permissions :update? do
    pending "add some examples to (or delete) #{__FILE__}"
  end

  permissions :destroy? do
    pending "add some examples to (or delete) #{__FILE__}"
  end
end
