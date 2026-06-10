require "rails_helper"

RSpec.describe "User registration", type: :request do
  describe "GET /register" do
    it "renders the registration form" do
      get register_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Create Account")
    end
  end

  describe "POST /register" do
    let(:user_params) do
      {
        email: "tester@example.com",
        password: "password",
        password_confirmation: "password"
      }
    end

    it "creates a new user and signs them in" do
      expect {
        post register_path, params: { user: user_params }
      }.to change(User, :count).by(1)

      expect(response).to redirect_to(root_path)
      follow_redirect!

      expect(response.body).to include("Welcome, tester@example.com!")
      expect(response.body).to include("Signed in as")
    end

    it "renders errors for invalid registration" do
      post register_path, params: { user: { email: "", password: "", password_confirmation: "" } }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("There was a problem creating your account.")
      expect(User.count).to eq(0)
    end
  end
end
