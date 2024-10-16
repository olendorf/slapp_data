# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Analyzable::Inventories', type: :request do
  let(:user) do
    user = FactoryBot.create :user
    server = FactoryBot.build(:server, user_id: user.id)
    server.save
    
    user
  end 

  let(:web_object) do
    web_object = FactoryBot.build :web_object, user_id: user.id
    web_object.save
    web_object
  end
  
  let(:path) { api_analyzable_transactions_path }

  describe 'POST' do
    context 'there are no splits' do 
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
      
    end
  end 
  
  context 'there are splits' do 
     
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
    
    context 'user splits' do 
      before(:each) do 
        user.splits << FactoryBot.build(:split, percent: 10)
        user.splits << FactoryBot.build(:split, percent: 15)
      end
      it 'adds the transactions to the user' do 
        expect do
          post path, params: attributes.to_json, headers: headers(web_object)
        end.to change(user.transactions, :count).by(3)
      end
      
      # it 'ends with the correct balance' do
      #   post path, params: attributes.to_json, headers: headers(web_object)
      #   expect(user.current_balance).to eq(75)
      # end
    end 
    
    context 'object splits' do 
      before(:each) do 
        web_object.splits << FactoryBot.build(:split, percent: 10)
        web_object.splits << FactoryBot.build(:split, percent: 15)
      end
      it 'adds the transactions to the web_ojbect' do 
        expect do
          post path, params: attributes.to_json, headers: headers(web_object)
        end.to change(web_object.transactions, :count).by(3)
      end
      
      it 'adds the transactions to the user' do 
        expect do
          post path, params: attributes.to_json, headers: headers(web_object)
        end.to change(user.transactions, :count).by(3)
      end
    end 
    
    context 'both splits' do 
      before(:each) do 
        web_object.splits << FactoryBot.build(:split, percent: 10)
        web_object.splits << FactoryBot.build(:split, percent: 15)
        user.splits << FactoryBot.build(:split, percent: 5)
      end
      it 'adds the transactions to the user' do 
        expect do
          post path, params: attributes.to_json, headers: headers(web_object)
        end.to change(user.transactions, :count).by(4)
      end    
      it 'adds the transactions to the web_object' do 
        expect do
          post path, params: attributes.to_json, headers: headers(web_object)
        end.to change(web_object.transactions, :count).by(3)
      end
    end
  end
  
end
