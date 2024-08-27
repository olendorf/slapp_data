# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.create :user }
  let(:admin) { FactoryBot.create :admin }
  let(:owner) { FactoryBot.create :owner }

  it { should respond_to :avatar_name }

  it {
    should define_enum_for(:role)
      .with_values(user: 0, admin: 1, owner: 2)
  }

  it {
    should have_many(
      :web_objects
    ).class_name('AbstractWebObject').dependent(:destroy)
  }

  describe '.servers' do
    it 'should return the correct number of servers' do
      3.times do
        server = FactoryBot.build :server
        user.web_objects << server
      end
      server = FactoryBot.build :server
      server.save
      web_object = FactoryBot.build :web_object
      user.web_objects << web_object
      expect(user.servers.count).to eq 3
    end
  end

  describe '.terminals' do
    it 'should return the correct number of servers' do
      3.times do
        terminal = FactoryBot.build :terminal
        user.web_objects << terminal
      end
      terminal = FactoryBot.build :terminal
      terminal.save
      web_object = FactoryBot.build :web_object
      user.web_objects << web_object
      expect(user.terminals.count).to eq 3
    end
  end

  it 'should override devise' do
    expect(user.email_required?).to be_falsey
    expect(user.email_changed?).to be_falsey
    expect(user.will_save_change_to_email?).to be_falsey
  end

  it 'should validate password complexity' do
    bad_user = FactoryBot.build :user, password: 'foobar123',
                                       password_confirmation: 'foobar123'
    expect(bad_user.valid?).to be_falsey
  end

  describe 'can be' do
    User.roles.each_key do |role|
      it { should respond_to :"can_be_#{role}?" }
    end
    it 'should properly test can_be_<role>?' do
      expect(admin.can_be_owner?).to be_falsey
      expect(admin.can_be_user?).to be_truthy
      expect(owner.can_be_user?).to be_truthy
      expect(user.admin?).to be_falsey
      expect(user.can_be_user?).to be_truthy
    end
  end

  describe 'is_active?' do
    it 'should return true for owners' do
      owner.expiration_date = 1.month.ago
      expect(owner.active?).to be_truthy
    end

    it 'should return true for active up-to-date users' do
      user.expiration_date = 1.month.from_now
      user.account_level = 1
      expect(user.active?).to be_truthy
    end

    it 'should return false for past due users' do
      user.expiration_date = 1.month.ago
      user.account_level = 1
      expect(user.active?).to be_falsey
    end
  end

  describe 'check_weight?' do
    it 'should return true if the user has sufficient reserve weight' do
      expect(user.check_object_weight?(FactoryBot.build(:web_object).object_weight))
        .to be_truthy
    end

    it 'should return false if the user lacks sufficient researve weight' do
      web_object = FactoryBot.build(:web_object)
      user.web_objects << web_object
      expect(user.check_object_weight?(FactoryBot.build(:web_object).object_weight))
        .to be_falsey
    end
  end

  describe 'adding web_objects' do
    let(:web_object) do
      FactoryBot.build :web_object
    end
    it 'should increment the object count' do
      old_count = user.web_object_count
      user.web_objects << web_object
      expect(user.web_object_count).to eq old_count + 1
    end

    it 'should increment the object weight' do
      old_weight = user.web_object_weight
      user.web_objects << web_object
      expect(user.web_object_weight).to eq old_weight +
                                           web_object.object_weight
    end
  end

  describe 'removing web_objects' do
    it 'should decrement the count' do
      user.web_objects << FactoryBot.build(:web_object)
      old_count = user.web_object_count
      user.web_objects.last.destroy
      expect(user.web_object_count).to eq old_count - 1
    end

    it 'should decrement the object weight' do
      web_object = FactoryBot.build :web_object
      user.web_objects << FactoryBot.build(:web_object)
      old_weight = user.web_object_weight
      user.web_objects.last.destroy
      expect(user.web_object_weight)
        .to eq old_weight - web_object.object_weight
    end
  end
end
