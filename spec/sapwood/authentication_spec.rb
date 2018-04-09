require 'spec_helper'

RSpec.describe Sapwood do

  describe '#authenticate' do
    let(:response) do
      Sapwood.authenticate(ENV['SAPWOOD_API_USER_EMAIL'], ENV['SAPWOOD_API_PASSWORD'])
    end

    it 'will raise 401 without correct credentials' do
      expect {
        Sapwood.authenticate(nil, ENV['SAPWOOD_API_USER_EMAIL'])
      }.to raise_error(RestClient::Unauthorized)
    end

    it 'returns the token, expires_at, user_id' do
      expect(response['token'].class).to eq(String)
      expect(response['token'].size).to eq(105)
      expect(response['user_id'].class).to eq(Fixnum)
      expect(response['expires_at'].class).to eq(Fixnum)
    end

    it 'stores the token in config' do
      response
      expect(Sapwood.configuration.token).to eq(response['token'])
    end
  end

end
