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
          password: "password",
          password_confirmation: "password"
        } 
      }
      before(:each) { post path, params: user_params.to_json, headers: headers(
              sending_object, api_key: Settings.default.web_object.api_key) }
      
      it 'should return created status' do 
        puts response.body
        expect(response).to have_http_status(:created)
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
end
