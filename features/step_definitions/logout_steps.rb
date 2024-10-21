Given('the user is logged in with the email {string} and password {string}') do |email, password|
  login_data = {
    email: email,
    password: password
  }

  @response = Faraday.post('/api/auth/login', login_data.to_json)

  unless @response.status == 200
    raise "Failed to log in: #{@response.body}"
  end

  @token = JSON.parse(@response.body)['data']['token']
end


When('the user attempts to log out with a valid token') do
  @response = Faraday.post('/api/auth/logout', {}.to_json, { Authorization: "Bearer #{@token}" })
end

When('the user attempts to log out with an invalid token') do
  invalid_token = "invalid_token"
  @response = Faraday.post('/api/auth/logout', {}.to_json, { Authorization: "Bearer #{invalid_token}" })
end

