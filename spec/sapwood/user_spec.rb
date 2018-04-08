require 'spec_helper'

RSpec.describe Sapwood::User do

  let(:property) { @property }

  let(:email) { Faker::Internet.email }
  let(:password) { ENV['SAPWOOD_API_PASSWORD'] }

  before(:each) do
    Sapwood.authenticate(ENV['SAPWOOD_API_ADMIN_EMAIL'], ENV['SAPWOOD_API_PASSWORD'])
    @property ||= Sapwood::Property.all.first
    Sapwood::Property.create(name: Faker::Lorem.words(4).join(' ')) if @property.blank?
    @property.activate!
  end

  # ---------------------------------------- | Create

  describe 'self#create' do
    it 'will create a user and return that user' do
      user = Sapwood::User.create(email: email, password: password)
      expect(user.class).to eq(Sapwood::User)
      expect(user.email).to eq(email)
      expect(user.id).to_not eq(nil)
    end
    it 'will not create a user when property is not set' do
      Sapwood.configuration.property_id = nil
      expect { Sapwood::User.create(email: email, password: password) }.to raise_error(ArgumentError)
    end
    it 'will not create a user without a token' do
      Sapwood.configuration.token = nil
      expect {
        Sapwood::User.create(email: email, password: password)
      }.to raise_error(RestClient::Unauthorized)
    end
  end

  # ---------------------------------------- | All

  describe 'self#all' do
    it 'will return an array of users' do
      users = Sapwood::User.all
      expect(users.class).to eq(Array)
      expect(users.collect(&:class).uniq).to eq([Sapwood::User])
    end
  end

  # ---------------------------------------- | Find

  describe 'self#find' do
    it 'will find a single user and return that user' do
      users = Sapwood::User.all
      user = Sapwood::User.find(users.first.id)
      expect(user.id).to eq(users.first.id)
      expect(user.email).to eq(users.first.email)
    end
  end

  # ---------------------------------------- | Instance Methods

  describe 'initialize' do
    it 'converts "_at" integer attributes to times' do
      time = Time.now.utc.to_i
      user = Sapwood::User.new(created_at: time)
      expect(user.created_at).to eq(Time.at(time))
    end
    it 'does not convert "_at" non-integers to times' do
      time = Time.now.utc
      user = Sapwood::User.new(created_at: time)
      expect(user.created_at).to eq(time)
    end
    it 'sets an instance variable for all attributes' do
      user = Sapwood::User.new(email: email)
      expect(user.instance_variable_get("@email")).to eq(email)
    end
  end

  describe 'destroy' do
    it 'will remove a user from a property' do
      user = Sapwood::User.create(email: email, password: password)
      users = Sapwood::User.all
      expect(users.collect(&:email)).to include(email)
      user.destroy
      users = Sapwood::User.all
      expect(users.collect(&:email)).to_not include(email)
    end
    it 'will not remove an admin user' do
      admin = Sapwood::User.all.select { |u| u.email == ENV['SAPWOOD_API_ADMIN_EMAIL'] }.first
      expect { admin.destroy }.to raise_error(RestClient::BadRequest)
    end
  end

end
