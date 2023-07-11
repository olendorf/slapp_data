class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :rememberable, :validatable, 
         :timeoutable, :trackable
         
         
  enum role: {
    user: 0,
    admin: 1,
    owner: 2
  }
end
