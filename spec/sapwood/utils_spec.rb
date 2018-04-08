require 'spec_helper'

RSpec.describe Sapwood::Utils do

  let(:utils) { Sapwood::Utils }

  describe '#request_url' do
    it 'combines api_url with a path to form a full request url' do
      request_url = utils.request_url('items')
      expect(request_url).to eq("#{ENV['SAPWOOD_API_URL']}/items")
    end
    it 'will remove trailing slash in api url' do
      Sapwood.configuration.api_url = ENV['SAPWOOD_API_URL'] + '/'
      expect(utils.request_url('items')).to eq("#{ENV['SAPWOOD_API_URL']}/items")
    end
    it 'adds query parameters, but requests that api_url also be passed' do
      params = { a: 1, b: 2 }
      exp_url = "#{ENV['SAPWOOD_API_URL']}/items?a=1&b=2"
      expect(utils.request_url('items', false, params)).to eq(exp_url)
    end
    it 'namespaces under the current property when requested' do
      Sapwood.configuration.property_id = 123
      exp_url = "#{ENV['SAPWOOD_API_URL']}/properties/123/items"
      expect(utils.request_url('items', true)).to eq(exp_url)
    end
  end

  describe '#auth_header' do
    it 'returns token header when token is set' do
      Sapwood.configuration.token = 'abc123'
      expect(utils.auth_header).to eq({ 'Authorization' => 'abc123' })
    end
    it 'returns key header when only key is set' do
      Sapwood.configuration.key = 'def456'
      expect(utils.auth_header).to eq({ 'API-Key' => 'def456' })
    end
    it 'returns token header when token and key are set' do
      Sapwood.configuration.token = 'abc123'
      Sapwood.configuration.key = 'def456'
      expect(utils.auth_header).to eq({ 'Authorization' => 'abc123' })
    end
  end

  # describe '#master_key_header' do
  #   it 'returns a hash given a master key' do
  #     expect(utils.master_key_header('abc123')).to eq({ 'Master-Key' => 'abc123' })
  #   end
  # end

  # describe '#api_key_header' do
  #   it 'returns a hash given a master key' do
  #     expect(utils.api_key_header('abc123')).to eq({ 'API-Key' => 'abc123' })
  #   end
  # end

end
