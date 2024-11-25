# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Analyzable::Transaction, type: :model do
  it { should belong_to :user }

  it { should belong_to(:abstract_web_object).optional(true) }

  it {
    should define_enum_for(:transaction_type)
      .with_values(other: 0, account: 1, share: 2)
  }

  let(:user) { FactoryBot.create :user }

  it 'should cover ransackable_associations method ' do
    expect(subject.class.ransackable_associations)
      .to include('abstract_web_object', 'user')
  end

  it 'should cover ransackable_attributes method ' do
    expect(subject.class.ransackable_attributes)
      .to include(
        'abstract_web_object_id', 'amount', 'balance', 'created_at',
        'description', 'id', 'id_value', 'previous_balance', 'target_key',
        'target_name', 'transaction_type', 'updated_at', 'user_id',
        'web_object_type'
      )
  end

  describe 'balance' do
    context 'first transaction' do
      let(:transaction) { FactoryBot.build :transaction }
      it 'should make the previous balance zero' do
        user.transactions << transaction
        expect(user.transactions.last.previous_balance).to eq 0
      end

      it 'should make the balance the amount' do
        user.transactions << transaction
        expect(user.transactions.last.balance).to eq transaction.amount
      end
    end

    context 'more than one transactions' do
      before(:each) do
        user.transactions << FactoryBot.build(:transaction, amount: 100)
        user.transactions << FactoryBot.build(:transaction, amount: 50)
      end

      let(:transaction) { FactoryBot.build :transaction, amount: 200 }

      it 'should have the correct previous balance' do
        user.transactions << transaction
        expect(user.transactions.last.previous_balance).to eq 150
      end

      it 'should have the correct balance' do
        user.transactions << transaction
        expect(user.transactions.last.balance).to eq 350
      end
    end
  end
end
