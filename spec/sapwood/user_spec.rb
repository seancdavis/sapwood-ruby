require 'spec_helper'

RSpec.describe Sapwood::User do

  let(:user) do
    Sapwood::Authentication.get_token(
      api_url: ENV['SAPWOOD_API_URL'],
      email: ENV['SAPWOOD_API_EMAIL'],
      password: ENV['SAPWOOD_API_PASSWORD']
    )
  end

  let(:name) { Faker::Lorem.words(rand(2..5)).join(' ').titleize }

  # ---------------------------------------- | New

  describe '#new' do
    it 'can instantiate a new user with a token' do
      user = Sapwood::User.new(token: 'abc123')
      expect(user.token).to eq('abc123')
    end
  end

  # ---------------------------------------- | Create Property

  describe '#create_property' do
    it 'will not create a property without a name' do
      expect { user.create_property(name: nil) }.to raise_error(RestClient::BadRequest)
    end
    it 'will not create a property without a valid token' do
      user.token = 'abc123'
      expect { user.create_property(name: name) }.to raise_error(RestClient::Unauthorized)
    end
    it 'will create a property with a valid token and name' do
      property = user.create_property(name: name)
      expect(property.api_url).to eq(ENV['SAPWOOD_API_URL'])
      expect(property.master_key.starts_with?("p#{property.id}_")).to eq(true)
      expect(property.id).to_not eq(nil)
      expect(property.name).to eq(name)
    end
  end

end
