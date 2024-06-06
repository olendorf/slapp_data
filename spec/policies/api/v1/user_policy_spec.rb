require 'rails_helper'

RSpec.describe Api::V1::UserPolicy, type: :policy do
  let(:user) { User.new }
  
  let(:user) { FactoryBot.create :user }
  let(:user_object) { 
    web_object = FactoryBot.build :web_object, user_id: user.id 
    web_object.save!
    web_object
  }
  
  let(:admin) { FactoryBot.create :admin }
  let(:admin_object) { 
    web_object = FactoryBot.build :web_object, user_id: admin.id 
    web_object.save!
    web_object
  }
  
  let(:owner) { FactoryBot.create :owner }
  let(:owner_object) { 
    web_object = FactoryBot.build :web_object, user_id: owner.id 
    web_object.save!
    web_object
  }

  subject { described_class }

  permissions :show?, :update?, :destroy? do
    it 'should allow objects owned by owners' do
        expect(subject).to permit owner, owner_object
    end
    
    it 'should not allow admin owned objects' do 
        expect(subject).to_not permit admin, admin_object
    end
    
    it 'should nto allow user owned objects' do 
        expect(subject).to_not permit user, user_object
    end
  end


      # expect(subject).to permit(User.new(admin: true), Post.new(published: true))
  permissions :create? do
    it 'always allows user creation' do
      expect(subject).to permit(nil, nil)
    end
  end

end
