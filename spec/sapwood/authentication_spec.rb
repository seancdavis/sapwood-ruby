require 'spec_helper'

RSpec.describe Sapwood do

  let(:response) do
    Sapwood.authenticate(ENV['SAPWOOD_API_USER_EMAIL'], ENV['SAPWOOD_API_PASSWORD'])
  end

  describe '#get_token' do
    it 'will raise 401 without correct credentials' do
      expect {
        Sapwood.authenticate(nil, ENV['SAPWOOD_API_USER_EMAIL'])
      }.to raise_error(RestClient::Unauthorized)
    end

    it 'returns the token' do
      expect(response.class).to eq(String)
      expect(response.size).to eq(105)
    end

    it 'stores the token in config' do
      expect(Sapwood.configuration.token).to eq(response)
    end
  end

end
