require 'rails_helper'
require 'support/shared_examples/unauthorized_roles'

RSpec.describe "Users API", type: :request do
    let(:super_admin) { 
        User.create!(
        first_name: "Admin",
        last_name: "User",
        email: "admin@example.com",
        password: "adminpassword",
        role: "super_admin"
        ) 
    }

    describe "POST /api/users" do

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

                prevCount = User.count
                post "/api/users", headers: { Authorization: "Bearer #{token}" }, params: invalid_user_attributes
                expect(response.status).to eql(422)

                json = JSON.parse(response.body)
                expect(json['errors']).to include(
                "first_name" => ["First name can't be blank"],
                "email" => ["Email is invalid"],
                "password" => ["Password is too short (minimum is 8 characters)"]
                )
                
                # Assert that no user was created
                expect(User.count).to eq(prevCount)
            end
        end

        context "when the user is artist_manager" do
            it_behaves_like "unauthorized for role" do
                let(:http_method) { :post}
                let(:role) { :artist_manager}
                let(:endpoint) { "/api/users" }
                let(:params) { valid_user_attributes }
            end
        end

        context "when the user is artist" do
            let(:http_method) { :post}
            let(:role) { :artist_manager}
            let(:endpoint) { "/api/users" }
            let(:params) { valid_user_attributes }
        end
    end

    describe "GET /api/users" do
        context "when the request is valid" do
            it "returns list of users with pagination data in meta field" do
                token = generate_token_for(super_admin)

                get "/api/users", headers: {Authorization: "Bearer #{token}"}
                json = JSON.parse(response.body)

                expect(response.status).to eql(200)

                expect(json["data"]).to include(
                    "users",
                    "meta"
                )
            end
        end

        context "when the token is invalid" do
            it_behaves_like "unauthenticated user" do
                let(:http_method) { :get}
                let(:endpoint) { "/api/users" }
                let(:params) { }
            end
        end
        
        context "when the user is artist_manager" do
            it_behaves_like "unauthorized for role" do
                let(:http_method) { :get}
                let(:role) { :artist_manager}
                let(:endpoint) { "/api/users" }
                let(:params) { }
            end
        end

        context "when the user is artist" do
            it_behaves_like "unauthorized for role" do
                let(:http_method) { :get}
                let(:role) { :artist}
                let(:endpoint) { "/api/users" }
                let(:params) { }
            end
        end
    end

    describe "GET /api/users/:id" do
        let(:created_manager) { 
          User.create!(
            first_name: "User",
            last_name: "User",
            email: "user1@example.com",
            password: "password",
            role: "artist_manager",
            dob: "2020-10-10",
            gender: "m",
            address: "Address"
          ) 
        }
        
        context "when the request is valid" do
          it "returns details of user" do
            token = generate_token_for(super_admin)
      
            get "/api/users/#{created_manager.id}", headers: { Authorization: "Bearer #{token}" }
            json = JSON.parse(response.body)
      
            expect(response.status).to eql(200)
            expect(json["data"]).to include("user")
          end
        end
      
        context "when the token is invalid" do
            it_behaves_like "unauthenticated user" do
                let(:endpoint) { "/api/users/#{created_manager.id}" }
                let(:params) { }
                let(:http_method) { :get}
            end
        end
        
        context "when the user is artist_manager" do
            it_behaves_like "unauthorized for role" do
                let(:http_method) { :get}
                let(:role) { :artist_manager}
                let(:endpoint) { "/api/users/#{created_manager.id}" }
                let(:params) { }
            end
        end
      
        context "when the user is artist" do
            it_behaves_like "unauthorized for role" do
                let(:http_method) { :get}
                let(:role) { "artist_manager"}
                let(:endpoint) { "/api/users/#{created_manager.id}" }
                let(:params) { }
            end
        end
    end
      
    
end
