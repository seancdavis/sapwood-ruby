require 'spec_helper'

RSpec.describe Sapwood::Property do

  let(:authenticate_user!) do
    Sapwood.authenticate(ENV['SAPWOOD_API_USER_EMAIL'], ENV['SAPWOOD_API_PASSWORD'])
  end

  let(:authenticate_admin!) do
    Sapwood.authenticate(ENV['SAPWOOD_API_ADMIN_EMAIL'], ENV['SAPWOOD_API_PASSWORD'])
  end

  let(:name) { Faker::Lorem.words(rand(2..5)).join(' ').titleize }

  # ---------------------------------------- | Create Property

  describe 'self#create' do
    it 'will not create a property without a name' do
      authenticate_admin!
      expect { Sapwood::Property.create(name: nil) }.to raise_error(RestClient::BadRequest)
    end
    it 'will not create a property without a token' do
      expect { Sapwood::Property.create(name: name) }.to raise_error(RestClient::Unauthorized)
    end
    it 'will not create a property without a valid token' do
      authenticate_user!
      expect { Sapwood::Property.create(name: name) }.to raise_error(RestClient::Unauthorized)
    end
    it 'will create a property with a valid token and name' do
      authenticate_admin!
      property = Sapwood::Property.create(name: name)
      expect(property.id).to_not eq(nil)
      expect(property.name).to eq(name)
    end
  end

  # ---------------------------------------- | Get Properties

  describe 'self#all' do
    it 'returns an array of property objects' do
      authenticate_admin!
      properties = Sapwood::Property.all
      expect(properties.class).to eq(Array)

      property = properties.first
      expect(property.class).to eq(Sapwood::Property)
      expect(property.id).to_not eq(nil)
      expect(property.name.present?).to eq(true)
    end
    it 'requires a valid token' do
      Sapwood.configuration.token = 'abc123'
      expect { Sapwood::Property.all }.to raise_error(RestClient::Unauthorized)
      authenticate_user!
      expect(Sapwood::Property.all.class).to eq(Array)
    end
  end

  describe 'self#where' do
    before(:each) { authenticate_admin! }
    it 'will filter a list of properties by id' do
      id = Sapwood::Property.all.first.id
      properties = Sapwood::Property.where(id: id)
      expect(properties.size).to eq(1)
      expect(properties.first.id).to eq(id)
    end
    it 'will filter a list of properties by name' do
      name = Sapwood::Property.all.first.name
      properties = Sapwood::Property.where(name: name)
      expect(properties.size).to eq(1)
      expect(properties.first.name).to eq(name)
    end
  end

  describe 'self#find_by' do
    before(:each) { authenticate_admin! }
    it 'will return the first matching instance from #where' do
      name = Sapwood::Property.all.first.name
      property = Sapwood::Property.find_by(name: name)
      expect(property.name).to eq(name)
    end
  end

  # ---------------------------------------- | Instance Methods

  describe '#initialize' do
    before(:each) { authenticate_admin! }
    it 'converts "_at" integer attributes to times' do
      time = Time.now.utc.to_i
      property = Sapwood::Property.new(created_at: time)
      expect(property.created_at).to eq(Time.at(time))
    end
    it 'does not convert "_at" non-integers to times' do
      time = Time.now.utc
      property = Sapwood::Property.new(created_at: time)
      expect(property.created_at).to eq(time)
    end
    it 'sets an instance variable for all attributes' do
      property = Sapwood::Property.new(name: 'Hello World')
      expect(property.instance_variable_get("@name")).to eq('Hello World')
    end
  end

  describe '#save' do
    before(:each) { authenticate_admin! }
    it 'calls create for new properties' do
      property = Sapwood::Property.new(name: name)
      expect(property).to receive(:create)
      property.save
    end
    it 'calls update for existing properties' do
      property = Sapwood::Property.all.first
      expect(property).to receive(:update)
      property.save
    end
  end

  describe '#create' do
    before(:each) { authenticate_admin! }
    it 'creates a new property and returns that property' do
      property = Sapwood::Property.create(name: name)
      expect(property.id).to_not eq(nil)
      expect(property.name).to eq(name)
    end
  end

  describe '#update' do
    before(:each) { authenticate_admin! }
    it 'updates an existing property' do
      property = Sapwood::Property.all.first
      property = property.update(name: name)
      expect(property.id).to_not eq(nil)
      expect(property.name).to eq(name)
    end
  end

  describe '#assign_attributes' do
    before(:each) { authenticate_admin! }
    it 'will bulk assign attributes and their instance variables (getters)' do
      time = Time.now.utc.to_i
      property = Sapwood::Property.all.first
      property.assign_attributes(name: name, created_at: time)
      expect(property.name).to eq(name)
      expect(property.attributes[:name]).to eq(name)
      expect(property.created_at).to eq(Time.at(time))
      expect(property.attributes[:created_at]).to eq(Time.at(time))
    end
  end

  describe '#name=(value)' do
    before(:each) { authenticate_admin! }
    it 'writes the name attribute and updates attributes hash' do
      property = Sapwood::Property.all.first
      expect(property).to receive(:assign_attributes).with(name: name)
      property.name = name
    end
  end

  describe '#activate!' do
    before(:each) { authenticate_admin! }
    it 'sets the config property_id to the current property\'s id' do
      property = Sapwood::Property.all.first
      expect(Sapwood.configuration.property_id).to eq(nil)
      property.activate!
      expect(Sapwood.configuration.property_id).to eq(property.id)
    end
  end

end
