RSpec.shared_examples "unauthorized for role" do
  it "returns an unauthorized error" do
    user = User.create!(
      first_name: "User",
      last_name: "Example",
      email: "#{role}@example.com",
      password: "userpassword",
      role: role
    )

    token = generate_token_for(user)

    send(http_method, endpoint, headers: { Authorization: "Bearer #{token}" }, params: params)
    expect(response.status).to eql(403)
  end
end
