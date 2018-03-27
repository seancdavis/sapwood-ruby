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
    let(:name) { @name }
    let(:client) { @client }

    before(:all) do
      @client = Sapwood::Client.new(api_url: ENV['SAPWOOD_API_URL'], api_key: @key.value)
      @new_items = []
      3.times do
        @new_items << @client.create_item(name: (@name = Faker::Name.name))
      end
    end

    it 'will retrieve an array of items' do
      items = client.get_items
      expect(items.class).to eq(Array)
      expect(items.first.class).to eq(Sapwood::Item)
      expect(items.collect(&:name)).to include(name)
    end
    it 'accepts filter parameters' do
      items = client.get_items(filter_by: :name, filter_value: name)
      exp_array = @new_items.select { |i| i.name == name }.collect(&:id)
      expect(items.size > 0).to eq(true)
      expect(items.collect(&:id)).to match_array(exp_array)
    end
    it 'accepts ordering parameters' do
      property = user.create_property(name: Faker::Book.name)
      key = property.create_key
      client = Sapwood::Client.new(api_url: ENV['SAPWOOD_API_URL'], api_key: key.value)
      new_items = []
      3.times { new_items << client.create_item(name: Faker::Name.name) }

      items = client.get_items(order_by: :name, order_in: :desc)
      exp_array = new_items.sort_by(&:name).reverse.collect(&:id)
      expect(items.size > 0).to eq(true)
      expect(items.collect(&:id)).to match_array(exp_array)
    end
  end

  # ---------------------------------------- | Get Item

  describe '#get_item' do
    it 'will retrieve an item directly with its id'
    it 'requires a valid id'
  end

end
