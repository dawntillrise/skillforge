require 'rails_helper'

RSpec.describe "Home Page", type: :request do
  describe "GET /" do
    it "returns HTTP success" do
      get root_path
      expect(response).to have_http_status(:success)
      expect(response.body).to include("SKILLFORGE")
      expect(response.body).to include("Sign In")
      expect(response.body).to include("Get Started")
    end
  end
end
