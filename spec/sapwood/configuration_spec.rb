require 'spec_helper'

RSpec.describe Sapwood do

  let(:api_url) { Faker::Lorem.sentence }
  let(:key) { Faker::Lorem.sentence }
  let(:property_id) { Faker::Lorem.sentence }
  let(:token) { Faker::Lorem.sentence }

  describe '#configuration' do
    it 'allows setting and getting each option' do
      Sapwood.configuration.api_url = api_url
      Sapwood.configuration.key = key
      Sapwood.configuration.property_id = property_id
      Sapwood.configuration.token = token

      expect(Sapwood.configuration.api_url).to eq(api_url)
      expect(Sapwood.configuration.key).to eq(key)
      expect(Sapwood.configuration.property_id).to eq(property_id)
      expect(Sapwood.configuration.token).to eq(token)
    end

    it 'has a default/fallback for api_url' do
      Sapwood.configuration.api_url = nil
      expect(Sapwood.configuration.api_url).to eq('https://api.sapwood.org')
    end
  end

  describe '#configure' do
    it 'will take a block to set options' do
      Sapwood.configure do |config|
        config.api_url = api_url
        config.key = key
        config.property_id = property_id
        config.token = token
      end

      expect(Sapwood.configuration.api_url).to eq(api_url)
      expect(Sapwood.configuration.key).to eq(key)
      expect(Sapwood.configuration.property_id).to eq(property_id)
      expect(Sapwood.configuration.token).to eq(token)
    end
  end

end
