# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'StaticPages', type: :request do
  describe 'GET /home' do
    it 'returns http success' do
      get '/static_pages/home'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /products' do
    it 'returns http success' do
      get '/static_pages/products'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /docs' do
    it 'returns http success' do
      get '/static_pages/docs'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /help' do
    it 'returns http success' do
      get '/static_pages/help'
      expect(response).to have_http_status(:success)
    end
  end
end
