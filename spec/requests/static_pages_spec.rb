require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  describe "GET /home" do
    it "returns http success" do
      get "/static_pages/home"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /admin" do
    it "returns http success" do
      get "/static_pages/admin"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /user" do
    it "returns http success" do
      get "/static_pages/user"
      expect(response).to have_http_status(:success)
    end
  end

end
