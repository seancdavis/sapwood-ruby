require 'spec_helper'

RSpec.describe Sapwood::Utils do

  let(:utils) { Sapwood::Utils }
  let(:dev_url) { ENV['SAPWOOD_API_URL'] }

  describe '#api_url' do
    it 'falls back to production url if not given a url' do
      expect(utils.api_url).to eq('https://api.sapwood.org')
    end

    it 'will return the string it was sent' do
      expect(dev_url.blank?).to eq(false)
      expect(utils.api_url(dev_url)).to eq(dev_url)
    end
  end

  describe '#request_url' do
    it 'combines api url with a path to form a full request url' do
      request_url = utils.request_url('items', dev_url)
      expect(request_url).to eq("#{dev_url}/items")
      expect(request_url.size.positive?).to eq(true)
    end
    it 'will fall back to the production url' do
      expect(utils.request_url('items')).to eq('https://api.sapwood.org/items')
    end
    it 'will remove trailing slash in api url' do
      expect(utils.request_url('items', "#{dev_url}/")).to eq("#{dev_url}/items")
    end
  end

end
