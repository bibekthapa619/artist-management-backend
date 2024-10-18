require 'rails_helper'
require 'support/shared_examples/unauthenticated_user'

RSpec.describe "Login API", type: :request do
    describe "POST /api/auth/login" do
        let(:user) { 
            User.create!(
                first_name: "John",
                last_name: "Doe",
                email: "john.doe@example.com",
                password: "password123",
                role: "super_admin"
            ) 
        }

        let(:valid_credentials) do
            {
                email: user.email,
                password: "password123"
            }
        end

        let(:invalid_credentials) do
            {
                email: "wrong.email@example.com",
                password: "wrongpassword"
            }
        end

        context "when the credentials are valid" do
            it "logs in the user and returns a token" do
                post "/api/auth/login", params: valid_credentials
                expect(response.status).to eql(200)

                json = JSON.parse(response.body)
                expect(json['data']).to have_key('token')
                expect(json['data']['token']).not_to be_empty
            end
        end

        context "when the credentials are invalid" do
            it "returns an unauthorized error" do
                post "/api/auth/login", params: invalid_credentials
                expect(response.status).to eql(422)
            end
        end
    end
end

RSpec.describe "Logout API", type: :request do
    describe "POST /api/auth/logout", type: :request do
        let(:user) { 
            User.create!(
                first_name: "John",
                last_name: "Doe",
                email: "john.doe@example.com",
                password: "password123",
                role: "super_admin"
            ) 
        }

        context "when the token is valid" do
            it "returns a success message" do
                token = generate_token_for(user)
                post "/api/auth/logout", headers: { Authorization: "Bearer #{token}" }
                expect(response.status).to eql(200)
            end
        end

        context "when the token is invalid" do
            it_behaves_like "unauthenticated user" do
                let(:http_method){ :post}
                let(:endpoint) {"/api/auth/logout"}
                let(:params) { }
            end
        end
    end
end

RSpec.describe "Me API", type: :request do
    describe "GET /api/auth/me", type: :request do
        let(:user) { 
            User.create!(
                first_name: "John",
                last_name: "Doe",
                email: "john.doe@example.com",
                password: "password123",
                role: "super_admin"
            ) 
        }

        context "when the token is valid" do
            it "returns a success message" do
                token = generate_token_for(user)
                get "/api/auth/me", headers: { Authorization: "Bearer #{token}" }
                expect(response.status).to eql(200)
                json = JSON.parse(response.body)
                expect(json["data"]).to include(
                    "id" => user.id,
                    "first_name" => user.first_name,
                    "last_name" => user.last_name,
                    "role" => user.role,
                    "email" => user.email
                )
            end
        end

        context "when the token is invalid" do
            it_behaves_like "unauthenticated user" do
                let(:http_method){ :get}
                let(:endpoint) {"/api/auth/me"}
                let(:params) { }
            end
        end
    end
end