When('A new user registers with the following details:') do |table|
  @user_data = table.hashes.first

  @response = Faraday.post("/api/auth/register", @user_data.to_json) 
end

Then('the user should be created with the following details:') do |table|
  expected_data = table.hashes.first

  login_response = Faraday.post("/api/auth/login",{ email: @user_data['email'], password: @user_data['password'] }.to_json) 

  user_details = JSON.parse(login_response.body)['data']['user']

  expect(user_details['first_name']).to eq(expected_data['first_name'])
  expect(user_details['last_name']).to eq(expected_data['last_name'])
  expect(user_details['email']).to eq(expected_data['email'])
  expect(user_details['role']).to eq(expected_data['role'])
end

