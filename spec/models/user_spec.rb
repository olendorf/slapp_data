require 'rails_helper'

RSpec.describe User, type: :model do
    it { should respond_to :avatar_name }
    
    it { should define_enum_for(:role).
            with_values(user: 0, admin: 1, owner: 2)}
end
