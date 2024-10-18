require 'rails_helper'

RSpec.describe "Register API", type: :request do
  describe "POST /api/auth/register" do
    let(:valid_attributes) do
      {
        first_name: "John",
        last_name: "Doe",
        email: "john.doe@example.com",
        password: "password123"
      }
    end

    let(:invalid_attributes) do
      {
        first_name: "",
        last_name: "",
        email: "invalidemail",
        password: "short"
      }
    end

    context "when the request is valid" do
      it "registers a new user" do
        post "/api/auth/register", params: valid_attributes
        expect(response.status).to eql(200)

        user = User.find_by(email: valid_attributes[:email])
        expect(user).not_to be_nil

        expect(user.first_name).to eql(valid_attributes[:first_name])
        expect(user.last_name).to eql(valid_attributes[:last_name])
        expect(user.email).to eql(valid_attributes[:email])
        expect(user.role).to eql("super_admin") 

        expect(user.authenticate(valid_attributes[:password])).to be_truthy
      end
    end

    context "when the request is invalid" do
      it "returns validation errors" do
        post "/api/auth/register", params: invalid_attributes
        expect(response.status).to eql(422)

        json = JSON.parse(response.body)
        expect(json['errors']).to include(
          "first_name" => ["First name can't be blank"],
          "last_name" => ["Last name can't be blank"],
          "email" => ["Email is invalid"],
          "password" => ["Password is too short (minimum is 8 characters)"]
        )
      end
    end
  end
end
