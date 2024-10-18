require 'rails_helper'

RSpec.describe "Users API", type: :request do
  describe "POST /api/users" do
    let(:super_admin) { 
      User.create!(
        first_name: "Admin",
        last_name: "User",
        email: "admin@example.com",
        password: "adminpassword",
        role: "super_admin"
      ) 
    }

    let(:valid_user_attributes) do
      {
        user: {
          first_name: "Manager",
          last_name: "Manager",
          email: "manager@example.com",
          password: "password123",
          phone: "9846011230",
          dob: "2024-09-06",
          gender: "m",
          role: "artist_manager", 
          address: "Pokhara"
        }
      }
    end

    let(:invalid_user_attributes) do
      {
        user: {
          first_name: "", 
          last_name: "Manager",
          email: "invalidemail",
          password: "short",
          phone: "9846011230",
          dob: "2024-09-06",
          gender: "m",
          role: "artist_manager",
          address: "Pokhara"
        }
      }
    end

    context "when the request is valid" do
      it "creates a new user" do
        token = generate_token_for(super_admin)

        expect {
          post "/api/users", headers: { Authorization: "Bearer #{token}" }, params: valid_user_attributes
        }.to change { User.count }.by(1) 
        
        expect(response.status).to eql(201)

        created_user = User.last
        expect(created_user.first_name).to eq(valid_user_attributes[:user][:first_name])
        expect(created_user.last_name).to eq(valid_user_attributes[:user][:last_name])
        expect(created_user.email).to eq(valid_user_attributes[:user][:email])
        expect(created_user.phone).to eq(valid_user_attributes[:user][:phone])
        expect(created_user.dob).to eq(Date.parse(valid_user_attributes[:user][:dob]))
        expect(created_user.gender).to eq(valid_user_attributes[:user][:gender])
        expect(created_user.role).to eq(valid_user_attributes[:user][:role]) 
        expect(created_user.address).to eq(valid_user_attributes[:user][:address])
      end
    end

    context "when the request is invalid" do
      it "returns validation errors" do
        token = generate_token_for(super_admin)

        post "/api/users", headers: { Authorization: "Bearer #{token}" }, params: invalid_user_attributes
        expect(response.status).to eql(422)

        json = JSON.parse(response.body)
        expect(json['errors']).to include(
          "first_name" => ["First name can't be blank"],
          "email" => ["Email is invalid"],
          "password" => ["Password is too short (minimum is 8 characters)"]
        )
        
        # Assert that no user was created
        expect(User.count).to eq(1)
      end
    end

    context "when the user is artist_manager" do
      it "returns an unauthorized error" do
        non_super_admin = User.create!(
          first_name: "User",
          last_name: "Example",
          email: "user@example.com",
          password: "userpassword",
          role: :artist_manager
        )

        token = generate_token_for(non_super_admin)

        post "/api/users", headers: { Authorization: "Bearer #{token}" }, params: valid_user_attributes
        
        expect(response.status).to eql(403)
      end
    end

    context "when the user is artist" do
      it "returns an unauthorized error" do
        non_super_admin = User.create!(
          first_name: "User",
          last_name: "Example",
          email: "user@example.com",
          password: "userpassword",
          role: :artist
        )

        token = generate_token_for(non_super_admin)

        post "/api/users", headers: { Authorization: "Bearer #{token}" }, params: valid_user_attributes
        
        expect(response.status).to eql(403)
      end
    end
  end
end
