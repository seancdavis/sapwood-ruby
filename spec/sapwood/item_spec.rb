# require 'spec_helper'

# RSpec.describe Sapwood::Item do

#   let(:options) { { api_key: 'abc123' } }

#   # ---------------------------------------- | New

#   describe '#new' do
#     it 'instantiates a new object' do
#       expect(Sapwood::Item.new(options).class).to eq(Sapwood::Item)
#     end
#     it 'raises an error when missing an API key' do
#       expect { Sapwood::Item.new }.to raise_error(ArgumentError)
#     end
#     it 'can set an API url' do
#       expect(Sapwood::Item.new(api_url: '123', api_key: 'abc123').api_url).to eq('123')
#     end
#     it 'defaults to the prod api when not given one' do
#       expect(Sapwood::Item.new(options).api_url).to eq('https://api.sapwood.org')
#     end
#   end

#   # ---------------------------------------- | Attributes

#   describe '#attributes, [dynamic attributes]' do
#     it 'fakes an accessor for an instantiated attribute' do
#       name = Faker::Name.name
#       item = Sapwood::Item.new(options, { name: name })
#       expect(item.name).to eq(name)
#       new_name = Faker::Book.name
#       item.name = new_name
#       expect(item.name).to eq(new_name)
#     end
#     it 'does not create accessors for all instances' do
#       item_01 = Sapwood::Item.new(options, { name: Faker::Name.name })
#       item_02 = Sapwood::Item.new(options, { title: Faker::Name.name })
#       expect { item_01.title }.to raise_error(NoMethodError)
#       expect { item_02.name }.to raise_error(NoMethodError)
#     end
#     it 'does not add a writer for the built-in attributes' do
#       item = Sapwood::Item.new(options, { id: 123 })
#       expect(item.id).to eq(123)
#       expect { item.id = 123 }.to raise_error(NoMethodError)
#     end
#   end

#   describe '#assign_attributes' do
#     it 'will assign attributes on the fly' do
#       item = Sapwood::Item.new(options)
#       item.assign_attributes(name: (name = Faker::Name.name), age: (age = rand(10..100)))
#       expect(item.name).to eq(name)
#       expect(item.age).to eq(age)
#       item.name = (new_name = Faker::Book.name)
#       expect(item.name).to eq(new_name)
#     end
#   end

#   # ---------------------------------------- | Data Conversion

#   describe '#post_data' do
#     it 'converts "_at" attributes to utc integers before save' do
#       item = Sapwood::Item.new(options, { publish_at: (date = DateTime.current) })
#       data = JSON.parse(item.send(:post_data)).deep_symbolize_keys
#       expect(data[:publish_at]).to eq(date.utc.to_i)
#     end
#   end

#   describe '#new' do
#     it 'presents "_at" attributes as datetime objects on the item' do
#       item = Sapwood::Item.new(options, { publish_at: (date = DateTime.current.utc.to_i) })
#       expect(item.publish_at).to eq(Time.at(date))
#     end
#   end

#   # ---------------------------------------- | Update / Save / Delete

#   context '[db transactions]' do
#     let(:user) { @user }
#     let(:property) { @property }
#     let(:key) { @key }
#     let(:item) { @item }
#     let(:client) { @client }

#     before(:all) do
#       @user = Sapwood::Authentication.get_token(
#         api_url: ENV['SAPWOOD_API_URL'],
#         email: ENV['SAPWOOD_API_USER_EMAIL'],
#         password: ENV['SAPWOOD_API_PASSWORD']
#       )
#       @property = @user.create_property(name: Faker::Book.name)
#       @key = @property.create_key
#       @client = Sapwood::Client.new(api_url: ENV['SAPWOOD_API_URL'], api_key: @key.value)
#       @item = @client.create_item(name: Faker::Name.name, age: rand(10..100))
#     end

#     describe 'item.update' do

#       it 'will update an existing item replacing an attribute' do
#         item.update(name: (name = Faker::Name.name))
#         expect(item.name).to eq(name)
#       end
#       it 'will add a new attribute without deleting others' do
#         old_name = item.name
#         old_age = item.age
#         item.update(title: (title = Faker::Book.title))
#         expect(item.title).to eq(title)
#         expect(item.name).to eq(old_name)
#         expect(item.name.blank?).to eq(false)
#         expect(item.age).to eq(old_age)
#         expect(item.age.blank?).to eq(false)
#       end
#     end

#     describe 'item.save' do
#       it 'can update an item directly by running the save method after adjusting attributes' do
#         old_age = item.age
#         item.name = (new_name = Faker::Name.name)
#         item.save
#         expect(item.name).to eq(new_name)
#         expect(item.age).to eq(old_age)
#         expect(item.age.blank?).to eq(false)
#       end
#     end

#     describe 'item.destroy' do
#       it 'will delete the item' do
#         id = item.id
#         res = item.destroy

#         expect(res).to eq(true)
#         expect { client.get_item(id: id) }.to raise_error(RestClient::NotFound)
#       end
#     end
#   end

# end
