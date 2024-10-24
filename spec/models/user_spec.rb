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

  it {
    should have_many(:transactions)
      .class_name('Analyzable::Transaction')
      .dependent(:destroy)
  }

  it {
    should have_many(
      :inventories
    ).class_name('Analyzable::Inventory').dependent(:destroy)
  }

  it { should have_many(:splits).dependent(:destroy) }

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

  describe 'adding transactions with splits' do
    before(:each) do
      user.web_objects << FactoryBot.build(:server)
      user.splits << FactoryBot.build(:split, percent: 10)
      user.splits << FactoryBot.build(:split, percent: 15)
    end

    it 'should add the splits' do
      expect do
        user.transactions << FactoryBot.build(:transaction, amount: 100)
      end.to change(user.transactions, :count).by(3)
    end

    it 'should result in the correct balance' do
      user.transactions << FactoryBot.build(:transaction, amount: 100)
      expect(user.current_balance).to eq 75
    end
  end

  describe 'account payments' do
    context 'new account' do
      let(:atts) do
        amount = Settings.default.account.monthly_cost * 3
        FactoryBot.attributes_for :user,
                                  account_payment: amount,
                                  requesting_object:,
                                  expiration_date: nil
      end

      let(:requesting_object) do
        requesting_object = FactoryBot.build :web_object
        owner.web_objects << requesting_object
        requesting_object
      end

      it 'should set the account level to 1' do
        user = User.create(atts)
        expect(user.account_level).to eq 1
      end

      it 'should update the expiration_date' do
        expected_date = Time.now + 3.months.to_i
        new_user = User.create(atts)
        expect(new_user.expiration_date).to be_within(2.seconds).of(expected_date)
      end

      it 'should add the transaction to the owner' do
        expect do
          User.create(atts)
        end.to change(owner.transactions, :count).by(1)
      end

      it 'should add the transaction to the user' do
        new_user = User.create(atts)
        expect(new_user.transactions.count).to eq 1
      end
    end

    context 'account level 1 ' do
      let(:existing_user) { FactoryBot.create :user, account_level: 1 }

      let(:requesting_object) do
        requesting_object = FactoryBot.build :web_object
        owner.web_objects << requesting_object
        requesting_object
      end

      it 'should update the expiration date' do
        amount = Settings.default.account.monthly_cost * 3
        expected_date = existing_user.expiration_date + 3.months.to_i
        existing_user.update(account_payment: amount, requesting_object:)
        expect(existing_user.expiration_date).to be_within(2.seconds).of(expected_date)
      end

      it 'should add the transaction to the owner' do
        amount = Settings.default.account.monthly_cost * 3
        expect do
          existing_user.update(account_payment: amount, requesting_object:)
        end.to change(owner.transactions, :count).by(1)
      end

      it 'should add the transaction to the user' do
        amount = Settings.default.account.monthly_cost * 3
        expect do
          existing_user.update(account_payment: amount, requesting_object:)
        end.to change(existing_user.transactions, :count).by(1)
      end
    end

    context 'account level 3' do
      let(:existing_user) { FactoryBot.create :user, account_level: 3 }

      let(:requesting_object) do
        requesting_object = FactoryBot.build :web_object
        owner.web_objects << requesting_object
        requesting_object
      end

      it 'should update the expiration date' do
        amount = Settings.default.account.monthly_cost * 3
        expected_date = existing_user.expiration_date +
                        ((amount.to_f / (Settings.default.account.monthly_cost *
                                  existing_user.account_level)) * 1.month.to_i)
        existing_user.update(account_payment: amount, requesting_object:)
        expect(existing_user.expiration_date).to be_within(2.seconds).of(expected_date)
      end

      it 'should add the transaction to the owner' do
        amount = Settings.default.account.monthly_cost * 3
        expect do
          existing_user.update(account_payment: amount, requesting_object:)
        end.to change(owner.transactions, :count).by(1)
      end

      it 'should add the transaction to the user' do
        amount = Settings.default.account.monthly_cost * 3
        expect do
          existing_user.update(account_payment: amount, requesting_object:)
        end.to change(existing_user.transactions, :count).by(1)
      end
    end
  end

  describe 'changing account level' do
    context 'changing account level up' do
      let(:current_user) do
        FactoryBot.create :user, account_level: 1, expiration_date: 3.months.from_now
      end

      it 'should change the expiration date correctly' do
        expected_date = Time.now +
                        ((current_user.expiration_date - Time.now) *
                                (current_user.account_level.to_f / 2))

        current_user.account_level = 2
        current_user.save

        expect(current_user.expiration_date).to be_within(2).of(expected_date)
      end
    end

    context 'changing account level down' do
      let(:current_user) do
        FactoryBot.create :user, account_level: 3, expiration_date: 3.months.from_now
      end
      it 'should change the expiration date correctly' do
        expected_date = Time.now +
                        ((current_user.expiration_date - Time.now) *
                            (current_user.account_level.to_f / 1))

        current_user.account_level = 1
        current_user.save

        expect(current_user.expiration_date).to be_within(2).of(expected_date)
      end
    end
  end
end
