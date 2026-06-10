require "rails_helper"

RSpec.describe "Sessions", type: :request do
  let!(:user) { User.create!(email: "tester@example.com", password: "password", password_confirmation: "password") }

  describe "GET /login" do
    it "renders the login page" do
      get login_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Sign In")
    end
  end

  describe "POST /login" do
    it "signs in with valid credentials" do
      post login_path, params: { session: { email: user.email, password: "password" } }

      expect(response).to redirect_to(root_path)
      follow_redirect!

      expect(response.body).to include("Signed in as")
      expect(response.body).to include(user.email)
    end

    it "rejects invalid credentials" do
      post login_path, params: { session: { email: user.email, password: "wrong" } }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("Invalid email or password.")
    end
  end

  describe "DELETE /logout" do
    it "signs out the user" do
      post login_path, params: { session: { email: user.email, password: "password" } }
      follow_redirect!

      delete logout_path

      expect(response).to redirect_to(root_path)
      follow_redirect!

      expect(response.body).to include("Signed out successfully.")
      expect(response.body).not_to include(user.email)
    end
  end
end
