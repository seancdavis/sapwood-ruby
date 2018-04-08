require 'spec_helper'

RSpec.describe Sapwood::Key do

  let(:property) { @property }

  let(:value) { SecureRandom.hex }

  before(:each) do
    Sapwood.authenticate(ENV['SAPWOOD_API_ADMIN_EMAIL'], ENV['SAPWOOD_API_PASSWORD'])
    @property ||= Sapwood::Property.all.first
    Sapwood::Property.create(name: Faker::Lorem.words(4).join(' ')) if @property.blank?
    @property.activate!
  end

  # ---------------------------------------- | Create

  describe 'self#create' do
    it 'will create a key and return that key' do
      key = Sapwood::Key.create
      expect(key.class).to eq(Sapwood::Key)
      expect(key.value).to_not eq(nil)
      expect(key.id).to_not eq(nil)
    end
    it 'will not create a key when property is not set' do
      Sapwood.configuration.property_id = nil
      expect { Sapwood::Key.create }.to raise_error(ArgumentError)
    end
    it 'will not create a key without a token' do
      Sapwood.configuration.token = nil
      expect { Sapwood::Key.create }.to raise_error(RestClient::Unauthorized)
    end
  end

  # ---------------------------------------- | All

  describe 'self#all' do
    it 'will return an array of keys' do
      keys = Sapwood::Key.all
      expect(keys.class).to eq(Array)
      expect(keys.collect(&:class).uniq).to eq([Sapwood::Key])
    end
  end

  # ---------------------------------------- | Find

  describe 'self#find' do
    it 'will find a single key and return that key' do
      keys = Sapwood::Key.all
      key = Sapwood::Key.find(keys.first.id)
      expect(key.id).to eq(keys.first.id)
      expect(key.value).to eq(keys.first.value)
    end
  end

  # ---------------------------------------- | Instance Methods

  describe 'initialize' do
    it 'converts "_at" integer attributes to times' do
      time = Time.now.utc.to_i
      key = Sapwood::Key.new(created_at: time)
      expect(key.created_at).to eq(Time.at(time))
    end
    it 'does not convert "_at" non-integers to times' do
      time = Time.now.utc
      key = Sapwood::Key.new(created_at: time)
      expect(key.created_at).to eq(time)
    end
    it 'sets an instance variable for all attributes' do
      key = Sapwood::Key.new(value: value)
      expect(key.instance_variable_get("@value")).to eq(value)
    end
  end

  describe 'destroy' do
    it 'will remove a key from a property' do
      key = Sapwood::Key.create
      value = key.value
      keys = Sapwood::Key.all
      expect(keys.collect(&:value)).to include(value)
      key.destroy
      keys = Sapwood::Key.all
      expect(keys.collect(&:value)).to_not include(value)
    end
  end

end
