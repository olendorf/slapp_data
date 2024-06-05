require 'rails_helper'

RSpec.describe User, type: :model do
    let(:user) { FactoryBot.build :user }
    it { should respond_to :avatar_name }
    
    it { should define_enum_for(:role).
            with_values(user: 0, admin: 1, owner: 2)}
            
    it { should have_many(:web_objects).class_name('AbstractWebObject').dependent(:destroy) }
    
    it 'should override devise' do 
        expect(user.email_required?).to be_falsey
        expect(user.email_changed?).to be_falsey
        expect(user.will_save_change_to_email?).to be_falsey
    end
    
    it 'should validate password complexity' do
        bad_user = FactoryBot.build :user, password: 'foobar123', password_confirmation: 'foobar123'
        expect(bad_user.valid?).to be_falsey
    end
end
