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
