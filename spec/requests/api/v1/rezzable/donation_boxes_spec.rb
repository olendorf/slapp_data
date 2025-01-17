# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Rezzable::DonationBoxes', type: :request do
  it_behaves_like 'it has a web object API', :donation_box
  
  let(:user) { FactoryBot.create :user }
  let(:donation_box) do 
    donation_box = FactoryBot.build :donation_box
    user.web_objects << donation_box
    donation_box
  end
  
  describe 'donation request' do 
    let(:path) { api_rezzable_donation_box_path(donation_box) }
    let(:attributes) do 
      { 
        donation: {
          amount: 100,
          target_key: "872bd905-268f-4c53-b9cc-7f05d4b3e0e3",
          target_name: 'Random Citizen',
        }
      }
      
    end 
    
    it 'should return ok status' do 
      put path, params: attributes.to_json, headers: headers(donation_box)
      # puts response.body
      expect(response).to have_http_status(:ok)
    end
    
    it 'should add a transaction to the donation box' do 
      expect{
                put path, 
                    params: attributes.to_json, 
                    headers: headers(donation_box)
            }.to change{donation_box.transactions.count}.by(1)
    end
    
    it 'should add a transaction t the user' do
      expect{
                put path, 
                    params: attributes.to_json, 
                    headers: headers(donation_box)
            }.to change{user.transactions.count}.by(1)
    end
    
    it 'should return the correct data' do 
      put path, params: attributes.to_json, headers: headers(donation_box)

      expect(JSON.parse(response.body)['data']).to include(
          'total' => 100,
          'last_tipper' => 'Random Citizen',
          'last_tip' => 100,
          'biggest_donor' => {
                                'target_name' => 'Random Citizen', 
                                'target_key' => "872bd905-268f-4c53-b9cc-7f05d4b3e0e3", 
                                'amount' => 100
                              }
        )
    end
  end
end
