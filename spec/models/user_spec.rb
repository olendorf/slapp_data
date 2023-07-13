require 'rails_helper'

RSpec.describe User, type: :model do
  
  let(:user)  { FactoryBot.create :user }
  let(:admin) { FactoryBot.build :admin }
  let(:owner) { FactoryBot.create :owner }
  
  it { should respond_to :avatar_name }
  it { should respond_to :avatar_key }
  it { should define_enum_for(:role).
            with_values(user: 0, admin: 1, owner: 2) }
            
  it "validates password length" do 
    expect(FactoryBot.build(:user, password: "1234567")).to_not be_valid
    expect(FactoryBot.build(:user)).to be_valid
  end
  
  it "validates password complexity" do 
    expect(FactoryBot.build(:user, password: "123456789")).to_not be_valid
    expect(FactoryBot.build(:user)).to be_valid
  end
            
  describe 'can be' do
    User.roles.each do |role, _value|
      it { should respond_to "can_be_#{role}?".to_sym }
    end
    it 'should properly test can_be_<role>?' do
      expect(admin.can_be_owner?).to be_falsey
      expect(admin.can_be_user?).to be_truthy
      expect(owner.can_be_user?).to be_truthy
      expect(user.admin?).to be_falsey
      expect(user.can_be_user?).to be_truthy
    end
  end
end
