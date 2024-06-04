require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  
  let(:sending_object) { 
    sending_object = FactoryBot.build(:web_object) 
    sending_object.save
    sending_object
  }
  
  describe "CREATE" do
    context 'valid request' do 
      let(:path) { api_users_path }
      let(:user_params) { 
        {
          avatar_name: "Random Citzen", 
          avatar_key: "01234567-89ab-cdef-0123456789ab",
          password: "Pa$$word123",
          password_confirmation: "Pa$$word123"
        } 
      }
      
      it 'should return created status' do
        post path, params: user_params.to_json, headers: headers(
              sending_object, api_key: Settings.default.web_object.api_key)
        expect(response).to have_http_status(:created)
      end
      
      it 'should create a user' do 
        expect{
            post path, params: user_params.to_json, headers: headers(
                sending_object, api_key: Settings.default.web_object.api_key)
        }.to change { User.count }.by(1)
      end
    end
    
    context 'passwords mismatch' do 
      let(:path) { api_users_path }
      let(:user_params) { 
        {
          avatar_name: "Random Citzen", 
          avatar_key: "01234567-89ab-cdef-0123456789ab",
          password: "Pa$$word123",
          password_confirmation: "notpassword"
        } 
      }
      before(:each) { post path, params: user_params.to_json, headers: headers(
              sending_object, api_key: Settings.default.web_object.api_key) }
      it 'should return a status' do 
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
    
    context 'password is too short' do 
      let(:path) { api_users_path }
      let(:user_params) { 
        {
          avatar_name: "Random Citzen", 
          avatar_key: "01234567-89ab-cdef-0123456789ab",
          password: "foo",
          password_confirmation: "foo"
        } 
      }
      before(:each) { post path, params: user_params.to_json, headers: headers(
              sending_object, api_key: Settings.default.web_object.api_key) }
      it 'should return a status' do 
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
  
  describe "GET" do
    let(:user) { FactoryBot.create :user }
    
    context 'with a valid api-key' do
    
      context 'when the user exists' do
        let(:path) { api_user_path(user.avatar_key) }
        before(:each) { get path, headers: headers(sending_object) }
        it 'shouild return OK status' do
          expect(response).to have_http_status(:ok)
        end
        it 'should return the user data' do 
          expect(JSON.parse(response.body).with_indifferent_access).to include(
              avatar_name: user.avatar_name, 
              avatar_key: user.avatar_key, 
              role: user.role,
              http_status: 'OK')
        end
      end
      
      context 'when the user does not exist' do
        let(:path) {api_user_path(SecureRandom.uuid)}
        before(:each) { get path, headers: headers(sending_object) }
        
        it 'should return NOT FOUND status' do
          expect(response).to have_http_status(:not_found)
        end
        
      end
      
    end
    
    context 'without a valid api-key' do
      let(:path) { api_user_path(user.avatar_key) }
      before(:each) { get path, headers: headers(sending_object, api_key: "bad") }
      
      it 'should return BAD REQUEST status' do
        expect(response).to have_http_status(:bad_request)
      end
      
      it 'should return a useful message' do 
        expect(JSON.parse(response.body)['message']).
                to eq "The request validation failed."
      end
    end
    
    context 'with a stale request' do
      let(:path) { api_user_path(user.avatar_key) }
      before(:each) { get path, 
              headers: headers(sending_object, auth_time: 1.minute.ago.to_i)
      }
      
      it 'should return BAD REQUEST status' do 
        expect(response).to have_http_status(:bad_request)
      end
      
      it 'should return a useful message' do 
        expect(JSON.parse(response.body)['message']).
                to eq "Stale request. Please try again."
      end
    end
      
  end
  
  describe "UPDATE" do 
    let(:user) { FactoryBot.create :user }
    let(:path) { api_user_path(user.avatar_key) }
    before(:each) { put path, params: user_params.to_json, headers: headers(sending_object) }
    
    context 'changing the password' do
      context 'valid password' do
        let(:user_params) { 
          {
            password: "NewPa$$word123", 
            password_confirmation: "NewPa$$word123"
          }
        }
        
        it 'should return OK status' do 
          expect(response).to have_http_status(:ok)
        end
        
        it 'should return the user data' do 
          expect(JSON.parse(response.body).with_indifferent_access[:data]).to include(
              avatar_name: user.avatar_name, 
              avatar_key: user.avatar_key, 
              role: user.role,
              http_status: 'OK')
        end
        
        it 'should return a nice message' do
          expect(JSON.parse(response.body)['message']).to eq "Your account has been updated."
        end
        
      end
      
      context 'invalid password' do 
        let(:user_params) { 
          {
            password: "NewPa$$word123", 
            password_confirmation: "OldPa$$word123"
          }
        }
        
        it 'should return OK status' do 
          expect(response).to have_http_status(:unprocessable_entity)
        end
        
        it 'should return a nice message' do
          expect(JSON.parse(response.body)['message']).
              to eq "Validation failed: Password confirmation doesn't match Password"
        end
      end
    end
  end
  
  describe 'DELETE' do 
    let(:user) { FactoryBot.create :user }
    let(:path) { api_user_path(user.avatar_key) }
    
    it 'should return OK status' do
      delete path, headers: headers(sending_object)
      expect(response).to have_http_status(:ok)
    end
    
    it 'it should return a nice message' do 
      delete path, headers: headers(sending_object)
      expect(JSON.parse(response.body)['message']).
          to eq "Your account has been deleted. Sorry to see you go!"
    end
  end
end
