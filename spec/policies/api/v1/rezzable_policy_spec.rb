# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::RezzablePolicy, type: :policy do
  # subject { described_class }

  # let(:user) { FactoryBot.build :user, expiration_date: 1.week.from_now }
  # let(:inactive_user) { FactoryBot.build :user, expiration_date: 1.week.ago }
  # let(:owner) { FactoryBot.build :owner }

  # let(:web_object) { FactoryBot.build :web_object }

  it_behaves_like 'it has a rezzable policy', :web_object
end
