# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Analyzable::Inventories', type: :request do
  let(:user) { FactoryBot.create :user }

  let(:web_object) do
    web_object = FactoryBot.build :web_object, user_id: user.id
    web_object.save
    web_object
  end

  describe 'POST' do
    let(:path) { api_analyzable_transactions_path }
    let(:avatar) { FactoryBot.build :avatar }
    let(:attributes) do
      {
        amount: 100,
        target_key: avatar.avatar_key,
        target_name: avatar.avatar_name,
        description: 'This is my description',
        web_object_type: web_object.class.name
      }
    end

    it 'returns CREATED status' do
      post path, params: attributes.to_json, headers: headers(web_object)
      expect(response.status).to eq 201
    end

    it 'should create a transaction for the user' do
      expect do
        post path, params: attributes.to_json, headers: headers(web_object)
      end.to change(user.transactions, :count).by(1)
    end

    it 'should add the transaction to the object' do
      expect do
        post path, params: attributes.to_json, headers: headers(web_object)
      end.to change(web_object.transactions, :count).by(1)
    end
    
    context 'when there are splits' do 
      before(:each) do 
        # split = FactoryBot.build :split, 
      end
    end
  end
  
end
