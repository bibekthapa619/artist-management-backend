Given('the following user exists:') do |table|
  user_data = table.hashes.first
  User.create!(
    first_name: user_data['first_name'],
    last_name: user_data['last_name'],
    email: user_data['email'],
    password: user_data['password'],
    role: user_data['role']
  )
end

When('the user attempts to log in with:') do |table|
  login_data = table.hashes.first

  @response = Faraday.post('/api/auth/login', login_data.to_json, { 'Content-Type' => 'application/json' })

end

Then('the response status should be {int}') do |status|
  expect(@response.status).to eql(status)
end

Then('the response should contain a token') do
  json_response = JSON.parse(@response.body)
  expect(json_response['data']).to have_key('token')
  expect(json_response['data']['token']).not_to be_empty
end



