# frozen_string_literal: true

# User model class
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable,  and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable,
         :timeoutable, :trackable

  validate :password_complexity

  has_many :web_objects, class_name: 'AbstractWebObject',
                         dependent: :destroy,
                         after_add: :increment_caches

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
end
