require 'spec_helper'

RSpec.describe Sapwood::Client do

  let(:user) { @user }
  let(:property) { @property }
  let(:key) { @key }

  let(:client) do
    Sapwood::Client.new(api_url: ENV['SAPWOOD_API_URL'], api_key: key.value)
  end

  before(:all) do
    @user = Sapwood::Authentication.get_token(
      api_url: ENV['SAPWOOD_API_URL'],
      email: ENV['SAPWOOD_API_EMAIL'],
      password: ENV['SAPWOOD_API_PASSWORD']
    )
    @property = @user.create_property(name: Faker::Book.name)
    @key = @property.create_key
  end

  # ---------------------------------------- | New

  describe '#new' do
    it 'instantiates a new object' do
      expect(Sapwood::Client.new(api_key: 'abc123').class).to eq(Sapwood::Client)
    end
    it 'raises an error when missing an API key' do
      expect { Sapwood::Client.new }.to raise_error(ArgumentError)
    end
    it 'can set an API url' do
      expect(Sapwood::Client.new(api_url: '123', api_key: 'abc123').api_url).to eq('123')
    end
    it 'defaults to the prod api when not given one' do
      expect(Sapwood::Client.new(api_key: 'abc123').api_url).to eq('https://api.sapwood.org')
    end
  end

  # ---------------------------------------- | Create Item

  describe '#create_item' do
    it 'will create an item and return an item object with appropriate attributes' do
      attrs = { name: (name = Faker::Name.name), age: (age = rand(10..100)) }
      item = client.create_item(attrs)

      expect(item.class).to eq(Sapwood::Item)
      expect(item.name).to eq(name)
      expect(item.age).to eq(age)
      expect(item.id > 0).to eq(true)
    end
    it 'will not create an item without a valid key' do
      client = Sapwood::Client.new(api_url: ENV['SAPWOOD_API_URL'], api_key: 'abc123')
      expect { client.create_item(name: Faker::Name.name) }.to raise_error(RestClient::Unauthorized)
    end
  end

  # ---------------------------------------- | Get Items

  describe '#get_items' do
    # TODO: Querying with filters, ordering
  end

  # ---------------------------------------- | Get Item

  describe '#get_item' do
    # TOOD: Query item directly
  end

end
