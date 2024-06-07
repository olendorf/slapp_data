
RSpec.shared_examples 'it has a rezzable policy' do |model_name|
    
    model_name = model_name.to_sym
    
    let(:active_user) { FactoryBot.create :user, expiration_date: 1.day.from_now }
    let(:active_object) { 
        active_object = FactoryBot.build :web_object 
        active_user.web_objects << active_object
        active_object
    }
  
    let(:underweight_user) { FactoryBot.create :user, expiration_date: 1.day.from_now }
    let(:new_object) { FactoryBot.build :web_object }
    
  
    let(:inactive_user) { FactoryBot.create :user, expiration_date: 1.day.ago }
    let(:inactive_object) { 
        inactive_object = FactoryBot.build :web_object, user_id: inactive_user.id 
        inactive_object.save
        inactive_user.web_object_count += 1
        inactive_user.web_object_weight += inactive_object.object_weight
        inactive_object
    }
  
    let(:owner) { FactoryBot.create :owner }
    let(:owner_object) {
        owner_object = FactoryBot.build :web_object
        owner.web_objects << owner_object
        owner_object
    }

    subject { described_class }
    
    permissions :show?, :destroy? do
        it 'should permit any user' do 
            expect(subject).to permit(inactive_user, inactive_object)
        end
        
        it 'should permit owners' do 
            expect(subject).to permit(owner, owner_object)
        end
    end

    permissions :create? do
        it 'should permit an active user with enough object weight' do
            expect(subject).to permit(underweight_user, new_object)
        end
        
        it 'should not permit when the user would go overweight' do
            expect(subject).to_not permit(active_user, active_object)
        end 
    end

    permissions :update? do
        it 'should permit an active user' do 
            expect(subject).to permit(active_user, active_object)
        end
        
        it 'should not permit an inactive user' do 
            expect(subject).to_not permit(inactive_user, inactive_object)
        end
        
        it 'should permit an owner' do 
            expect(subject).to permit(owner, owner_object)
        end
    end
  
end