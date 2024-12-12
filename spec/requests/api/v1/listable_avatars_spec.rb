require 'rails_helper'

RSpec.describe "ListableAvatars", type: :request do
  let(:user) { FactoryBot.create :user }

  
  describe "GET /index" do
    context 'getting traffic cop list' do 
      let(:traffic_cop) do
        traffic_cop = FactoryBot.build :traffic_cop
        user.web_objects << traffic_cop
        
        15.times do |index|
          traffic_cop.listable_avatars << FactoryBot
                          .build(:allowed, 
                                    avatar_name: "Allowed_#{index} Citizen")
        end
        
        17.times do |index|
          traffic_cop.listable_avatars << FactoryBot
                          .build(:banned, 
                                    avatar_name: "Banned_#{index} Citizen")
        end
        
        traffic_cop
      end
      
      let(:path) { api_listable_avatars_path }
      
      context 'getting allowed list' do 
        it 'should return ok status' do 
          get path, params: {list_name: 'allowed'}, headers: headers(traffic_cop)
          expect(response).to have_http_status(:ok)
        end
        
        context 'first page' do 
          it 'should return the correct data' do 
            get path, params: {list_name: 'allowed'}, 
                      headers: headers(traffic_cop)
            expected = traffic_cop.allowed[0..8].collect do |a| 
              a.avatar_key
            end
            observed = JSON.parse(response.body)['data']['allowed'].collect do |a|
              a['avatar_key']
            end
            expect(observed)
                .to eq(expected)
          end
        end
        
        context 'last page' do 
          it 'should return the correct data' do 
            get path, 
                params: {list_name: 'allowed', listable_avatar_page: 2},
                headers: headers(traffic_cop)
            
            
            expected = traffic_cop.allowed[9..-1].collect do |a| 
              a.avatar_key
            end
            observed = JSON.parse(response.body)['data']['allowed'].collect do |a|
              a['avatar_key']
            end
            
            expect(observed)
                .to eq(expected)
          end
        end
      end 
      
      context 'getting banned list' do 
        it 'should return ok status' do 
          get path, params: {list_name: 'banned'}, headers: headers(traffic_cop)
          expect(response).to have_http_status(:ok)
        end
        
        context 'first page' do 
          it 'should return the correct data' do 
            get path, params: {list_name: 'banned'}, 
                      headers: headers(traffic_cop)
            expected = traffic_cop.banned[0..8].collect do |a| 
              a.avatar_key
            end
            observed = JSON.parse(response.body)['data']['banned'].collect do |a|
              a['avatar_key']
            end
            expect(observed)
                .to eq(expected)
          end
        end
        
        context 'last page' do 
          it 'should return the correct data' do 
            get path, 
                params: {list_name: 'banned', listable_avatar_page: 2},
                headers: headers(traffic_cop)
            expected = traffic_cop.banned[9..-1].collect do |a| 
              a.avatar_key
            end
            observed = JSON.parse(response.body)['data']['banned'].collect do |a|
              a['avatar_key']
            end
            
            expect(observed)
                .to eq(expected)
          end
        end
      end
      
    end
  end
end
