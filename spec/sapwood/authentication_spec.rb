require 'spec_helper'

RSpec.describe Sapwood::Authentication do

  let(:response) do
    Sapwood::Authentication.get_token(
      api_url: ENV['SAPWOOD_API_URL'],
      email: ENV['SAPWOOD_API_EMAIL'],
      password: ENV['SAPWOOD_API_PASSWORD']
    )
  end

  describe '#get_token' do
    it 'will raise 401 without correct credentials' do
      expect {
        Sapwood::Authentication.get_token(
          api_url: ENV['SAPWOOD_API_URL'], email: ENV['SAPWOOD_API_EMAIL']
        )
      }.to raise_error(RestClient::Unauthorized)
    end

    it 'will return a user object on success' do
      expect(response.class).to eq(Sapwood::User)
    end

    it 'will return a user object with a token' do
      expect(response.token).to_not eq(nil)
      expect(response.token.class).to eq(String)
      expect(response.token.size.positive?).to eq(true)
    end
  end

end
