require 'spec_helper'

RSpec.describe Sapwood::Key do

  let(:authenticate_admin!) do
    Sapwood.authenticate(ENV['SAPWOOD_API_ADMIN_EMAIL'], ENV['SAPWOOD_API_PASSWORD'])
  end

  let(:property) { Sapwood::Property.all.first }

  before(:all) do
    Sapwood::Property.create(name: Faker::Lorem.words(4).join(' ')) if property.blank?
  end

#   # # ---------------------------------------- | New

#   describe '#new' do
#     it 'can be instantiated with the correct options and attributes' do
#       options = { api_url: ENV['SAPWOOD_API_URL'], master_key: 'abc123' }
#       attrs = { name: 'Test Test', id: 123 }
#       property = Sapwood::Property.new(options, attrs)
#       expect(property.api_url).to eq(ENV['SAPWOOD_API_URL'])
#       expect(property.master_key).to eq('abc123')
#       expect(property.name).to eq('Test Test')
#       expect(property.id).to eq(123)
#     end
#   end

  # ---------------------------------------- | Create Key

  # describe '#create_key' do
  #   it 'will create and return a key' do
  #     key = property.create_key
  #     expect(key.value.starts_with?("p#{property.id}_")).to eq(true)
  #   end
  #   it 'will not create a key without a key' do
  #     property.master_key = 'abc123'
  #     expect { property.create_key(master: true) }.to raise_error(RestClient::Unauthorized)
  #   end
  # end

#   # ---------------------------------------- | Get Keys

#   describe '#get_keys' do
#     it 'returns an array of property objects' do
#       keys = property.get_keys
#       expect(keys.class).to eq(Array)

#       key = keys.first
#       expect(key.class).to eq(Sapwood::Key)
#       expect(key.value.starts_with?("p#{property.id}_")).to eq(true)
#       expect(key.id).to_not eq(nil)
#     end
#     it 'requires a valid master key' do
#       property.master_key = 'abc123'
#       expect { property.get_keys }.to raise_error(RestClient::Unauthorized)
#     end
#   end

#   # ---------------------------------------- | Get Key

#   describe '#get_key' do
#     let(:keys) { property.get_keys }
#     it 'returns a key object' do
#       key = property.get_key(id: keys.first.id)
#       expect(key.class).to eq(Sapwood::Key)
#       expect(key.value.starts_with?("p#{property.id}_")).to eq(true)
#       expect(key.id).to_not eq(nil)
#     end
#     it 'requires a valid token' do
#       property.master_key = 'abc123'
#       expect { property.get_key(id: keys.first.id) }
#         .to raise_error(RestClient::Unauthorized)
#     end
#     it 'requires an id' do
#       expect { property.get_key }.to raise_error(ArgumentError)
#     end
#     it 'requires a valid id' do
#       expect { property.get_key(id: 0) }.to raise_error(RestClient::NotFound)
#     end
#   end

#   # ---------------------------------------- | Delete Key

#   describe '#delete_key' do
#     let(:keys) { property.get_keys }
#     let(:key) { property.create_key }
#     before(:each) { key }
#     it 'deletes the key' do
#       response = property.delete_key(id: key.id)
#       expect(response).to eq(true)
#       expect { property.get_key(id: key.id) }.to raise_error(RestClient::NotFound)
#     end
#     it 'requires a valid token' do
#       property.master_key = 'abc123'
#       expect { property.delete_key(id: key.id) }.to raise_error(RestClient::Unauthorized)
#     end
#     it 'requires an id' do
#       expect { property.delete_key }.to raise_error(ArgumentError)
#     end
#     it 'requires a valid id' do
#       expect { property.delete_key(id: 0) }.to raise_error(RestClient::NotFound)
#     end
#   end

end
