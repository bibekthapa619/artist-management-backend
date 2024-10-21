require 'faraday'
require 'dotenv/load'  # Load environment variables from .env file

# Configure Faraday to use the TEST_URL from the .env file
Faraday.default_connection = Faraday.new(url: ENV['TEST_URL']) do |conn|
  conn.adapter Faraday.default_adapter
  conn.headers['Content-Type'] = 'application/json'
end
