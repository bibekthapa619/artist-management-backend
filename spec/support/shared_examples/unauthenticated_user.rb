RSpec.shared_examples "unauthenticated user" do |http_method, endpoint, params = {}|
    it "returns an unauthenticated error" do
      token = "adasdsadsadad"
      send(http_method, endpoint, headers: { Authorization: "Bearer #{token}" }, params: params)
      expect(response.status).to eql(401)
    end
end
