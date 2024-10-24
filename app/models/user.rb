# frozen_string_literal: true

# User model class
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable,  and :omniauthable
  devise :database_authenticatable, :rememberable, :validatable,
         :timeoutable, :trackable

  validate :password_complexity
  
  attr_accessor :account_payment, :requesting_object
  
  before_update :handle_account_payment!, if: :account_payment
  after_create :handle_account_payment!, if: :account_payment
  before_update :adjust_expiration_date!, if: :will_save_change_to_account_level?

  has_many :web_objects, class_name: 'AbstractWebObject',
                         dependent: :destroy,
                         after_add: :increment_caches
  has_many :inventories, class_name: 'Analyzable::Inventory',
                         dependent: :destroy
  has_many :transactions, class_name: 'Analyzable::Transaction',
                          dependent: :destroy,
                          before_add: :update_balance,
                          after_add: :handle_splits
  has_many :splits, dependent: :destroy, as: :splittable

  def email_required?
    false
  end

  def email_changed?
    false
  end

  def will_save_change_to_email?
    false
  end

  enum :role, {
    user: 0,
    admin: 1,
    owner: 2
  }

  def servers
    Rezzable::Server.where(user_id: id)
  end

  def terminals
    Rezzable::Terminal.where(user_id: id)
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[
      account_level avatar_key avatar_name created_at
      current_sign_in_at current_sign_in_ip expiration_date id
      id_value last_sign_in_at last_sign_in_ip remember_created_at
      role sign_in_count updated_at web_object_count
      web_object_weight
    ]
  end

  def self.ransackable_associations(_auth_object = nil)
    ['web_objects']
  end

  # Creates methods to test of a user is allowed to act as a role.
  # Given ROLES = [:user, :prime, :admin, :owner], will create the methods
  # #can_be_guest?, #can_be_user?, #can_be_admin? and #can_be_owner?.
  #
  # The methods return true if the user's role is equal to or less than the
  # rank of the can_be method. So if a user is an admin, #can_be_user? or
  # #can_be_admin? would return true, but
  # can_be_owner? would return false.
  #
  User.roles.each do |role_name, value|
    define_method("can_be_#{role_name}?") do
      value <= self.class.roles[role]
    end
  end

  # Determines is a user has an active account.
  def active?
    return true if can_be_owner?

    expiration_date >= Time.now
  end

  def check_object_weight?(object_weight)
    web_object_weight + object_weight <=
      Settings.default.account.weight_limit
  end
  
  def current_balance
    if transactions.count == 0
      0
    else
      transactions.last.balance
    end
  end

  private

  def increment_caches(web_object)
    self.web_object_count += 1
    self.web_object_weight += web_object.object_weight
    save
  end

  def password_complexity
    # Regexp extracted from https://stackoverflow.com/questions/19605150/regex-for-password-must-contain-at-least-eight-characters-at-least-one-number-a
    if password.blank? || password =~ /(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-])/
      return
    end

    errors.add :password,
               'Complexity requirement not met. Please use: " + "
               1 uppercase, 1 lowercase, 1 digit and 1 special character.'
  end

  def update_balance(transaction)
    previous_transaction = transactions.last
    if previous_transaction.nil?
      transaction.previous_balance = 0
      transaction.balance = transaction.amount
    else
      transaction.previous_balance = previous_transaction.balance
      transaction.balance = previous_transaction.balance + transaction.amount
    end
  end
  
  def handle_splits(transaction)
    return if transaction.transaction_type == :share || transaction.amount <= 0

    splits.each do |share|
      handle_split(transaction, share)
    end
  end
  
  
  def handle_split(transaction, share)
    server = servers.sample
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
    self.transactions << transaction
    # target = User.find_by_avatar_key(share.target_key)
    # add_transaction_to_target(target, amount) if target
  end
  
  # rubocop:disable Metrics/AbcSize
  def handle_account_payment!
    update_column(:account_level, 1) if account_level.zero?
    added_time = account_payment.to_f / (
                        account_level * Settings.default.account.monthly_cost)
    self.expiration_date = Time.now if
      expiration_date.nil? || expiration_date < Time.now
    self.expiration_date = expiration_date + (1.month.to_i * added_time)
    add_account_transaction_to_target(self, requesting_object, account_payment * -1)
    add_account_transaction_to_target(requesting_object.user, requesting_object, account_payment)
  end
  # rubocop:enable Metrics/AbcSize

  def add_account_transaction_to_target(target, requesting_object, amount)
    target.transactions << ::Analyzable::Transaction.new(
      amount: amount,
      target_key: requesting_object.user.avatar_key,
      target_name: requesting_object.user.avatar_name,
      abstract_web_object_id: requesting_object.id,
      web_object_type: requesting_object.class.name,
      # source_type: 'terminal',
      transaction_type: :account,
      description: "Account payment from #{self.avatar_name}."
    )
  end

  def adjust_expiration_date!
    return if will_save_change_to_expiration_date?
    update_column(:expiration_date, Time.now) and return if account_level.zero?

    update_column(:expiration_date,
                  Time.now + ((expiration_date - Time.now) *
                  (account_level_was.to_f / account_level)))
  end
end
