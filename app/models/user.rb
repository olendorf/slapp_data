class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :rememberable, 
         :timeoutable, :trackable, :validatable
  

  validate :password_complexity
         
  enum role: {
    user: 0,
    admin: 1,
    owner: 2
  }
  
  def password_complexity
    if password.blank? || password =~ /(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-])/
      return
    end

    errors.add :password,
               'Complexity requirement not met. Please use: 1 uppercase, ' +
               '1 lowercase, 1 digit and 1 special character'
  end
  
  # THese two methods need to be overridden to deal with Devise's need 
  # for emails.
  def email_required?
    false
  end

  def email_changed?
    false
  end
  
  # use this instead of email_changed? for rails >= 5.1
  def will_save_change_to_email?
    false
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
  
  
end
