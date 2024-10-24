# frozen_string_literal: true

# Base model for rezzable objects
class AbstractWebObject < ApplicationRecord
  after_initialize :set_api_key
  before_destroy :decrement_user_caches

  actable

  belongs_to :user, touch: true, required: false
  belongs_to :server, touch: true, required: false, class_name: 'Rezzable::Server'

  has_many :transactions, class_name: 'Analyzable::Transaction',
                          dependent: :nullify,
                          after_add: :handle_splits
  has_many :splits, dependent: :destroy, as: :splittable

  def object_weight
    actable.class::OBJECT_WEIGHT
  end

  def decrement_user_caches
    user.web_object_count -= 1
    user.web_object_weight -= object_weight
    user.save
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[id id_value object_name description region]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[actable user]
  end

  private

  def set_api_key
    self.api_key ||= SecureRandom.uuid
  end

  def handle_splits(transaction)
    return if transaction.transaction_type == :share || transaction.amount <= 0

    splits.each do |share|
      handle_split(transaction, share)
    end
  end

  def handle_split(transaction, share)
    server = user.servers.sample
    return unless server

    amount = (share.percent / 100.0 * transaction.amount).round
    # ServerSlRequest.send_money(server,
    #                           share.target_name,
    #                           amount)
    # add_transaction_to_user(transaction, amount, share)
    transaction = Analyzable::Transaction.new(
      amount: amount * -1,
      target_key: share.target_key,
      target_name: share.target_name,
      description: "Split paid to #{share.target_name}",
      transaction_type: :share
    )
    user.transactions << transaction
    transactions << transaction
    # target = User.find_by_avatar_key(share.target_key)
    # add_transaction_to_target(target, amount) if target
  end
end
