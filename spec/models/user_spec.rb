# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  let(:user)  { create(:user) }
  let(:admin) { build(:admin) }
  let(:owner) { create(:owner) }

  it { is_expected.to respond_to :avatar_name }
  it { is_expected.to respond_to :avatar_key }

  it { is_expected.to have_many(:web_objects).class_name('AbstractWebObject').dependent(:destroy) }

  it {
    expect(subject).to define_enum_for(:role)
      .with_values(user: 0, admin: 1, owner: 2)
  }

  it 'validates password length' do
    expect(build(:user, password: '1234567')).not_to be_valid
    expect(build(:user)).to be_valid
  end

  it 'validates password complexity' do
    expect(build(:user, password: '123456789')).not_to be_valid
    expect(build(:user)).to be_valid
  end

  describe '#is_active?' do
    it 'returns true if the user is owner' do
      expect(owner).to be_active
    end

    it 'returns true if the users account is up to date' do
      user.expiration_date = 1.week.from_now
      expect(user).to be_active
    end

    it 'returns false if the user is behind payments' do
      user.expiration_date = 1.week.ago
      expect(user).not_to be_active
    end
  end

  describe 'can be' do
    described_class.roles.each do |role, _value|
      it { is_expected.to respond_to "#{role}?".to_sym }
    end
    it 'properly tests can_be_<role>?' do
      expect(admin).not_to be_owner
      expect(admin).to be_user
      expect(owner).to be_user
      expect(user).not_to be_admin
      expect(user).to be_user
    end
  end
end
