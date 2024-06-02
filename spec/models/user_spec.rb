require 'rails_helper'

RSpec.describe User, type: :model do
    let(:user) { FactoryBot.build :user }
    it { should respond_to :avatar_name }
    
    it { should define_enum_for(:role).
            with_values(user: 0, admin: 1, owner: 2)}
            
    it { should have_many(:abstract_web_objects) }
    
    it 'should override devise' do 
        expect(user.email_required?).to be_falsey
        expect(user.email_changed?).to be_falsey
        expect(user.will_save_change_to_email?).to be_falsey
    end
end
