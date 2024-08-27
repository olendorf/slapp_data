# frozen_string_literal: true

RSpec.shared_examples 'a rezzable object' do |model_name, object_weight|
  let(:user) { FactoryBot.create :user }
  let(:web_object) do
    web_object = FactoryBot.build model_name.to_sym
    web_object
  end
  describe '#object_weight' do
    it 'should return the correct weight' do
      expect(web_object.object_weight).to eq object_weight
    end
  end

  context "creating a #{model_name}" do
    describe 'updating object_count' do
      it 'should update the count when there is a user' do
        web_object = FactoryBot.build model_name.to_sym
        user.web_objects << web_object
        expect(user.reload.web_object_count).to eq 1
      end
    end

    describe 'updating object_weight' do
      it 'should update the object weight correclty' do
        web_object = FactoryBot.build model_name.to_sym
        user.web_objects << web_object
        expect(user.reload.web_object_weight).to eq object_weight
      end
    end
  end
  
  it 'should cover ransackable_attributes method ' do 
    expect(subject.class).to respond_to(:ransackable_attributes)
  end
  
  it 'should cover ransackable_associations method ' do 
    expect(subject.class).to respond_to(:ransackable_associations)
  end

  context "destroying a #{model_name}" do
    before(:each) do
      web_object = FactoryBot.build model_name.to_sym
      user.web_objects << web_object
      user.reload
    end
    describe 'updating object_count' do
      it 'should decrement the count' do
        user.web_objects.last.destroy
        expect(user.web_object_count).to eq 0
      end
    end

    describe 'updating object_weight' do
      it 'should decrement the weight' do
        user.web_objects.last.destroy
        expect(user.web_object_weight).to eq 0
      end
    end
  end
end
