require 'spec_helper'

RSpec.describe Sapwood::Item do

  let(:property) { @property }

  let(:name) { Faker::Name.name }
  let(:age) { rand(10..100) }

  let(:key) do
    @key = Sapwood::Key.all.first
    @key = Sapwood::Key.create if @key.blank?
    @key
  end

  let(:user) do
    @user = Sapwood::User.all.select { |u| u.email == ENV['SAPWOOD_API_USER_EMAIL'] }.first
    if @user.blank?
      @user = Sapwood::User.create(
        email: ENV['SAPWOOD_API_USER_EMAIL'],
        password: ENV['SAPWOOD_API_PASSWORD']
      )
    end
    @user
  end

  let(:authenticate_user!) do
    user
    Sapwood.authenticate(ENV['SAPWOOD_API_USER_EMAIL'], ENV['SAPWOOD_API_PASSWORD'])
  end

  let(:authenticate_key!) { key.activate! }

  let(:params) { { name: name, age: age } }

  before(:each) do
    Sapwood.authenticate(ENV['SAPWOOD_API_ADMIN_EMAIL'], ENV['SAPWOOD_API_PASSWORD'])
    @property ||= Sapwood::Property.all.first
    Sapwood::Property.create(name: Faker::Lorem.words(4).join(' ')) if @property.blank?
    @property.activate!
  end

  # ---------------------------------------- | Create

  describe 'self#create' do
    it 'creates and returns item with appropriate attributes' do
      authenticate_user!
      item = Sapwood::Item.create(params)
      expect(item.class).to eq(Sapwood::Item)
      expect(item.name).to eq(name)
      expect(item.age).to eq(age)
      expect(item.meta[:id] > 0).to eq(true)
    end
    it 'will create an item using a key' do
      authenticate_key!
      item = Sapwood::Item.create(params)
      expect(item.meta[:id] > 0).to eq(true)
    end
    it 'will not create an item without a token or key' do
      Sapwood.configuration.token = nil
      Sapwood.configuration.key = nil
      expect { Sapwood::Item.create(params) }.to raise_error(RestClient::Unauthorized)
    end
  end

  # ---------------------------------------- | Query

  describe 'self#query', 'self#all' do
    before(:each) do
      authenticate_user!
      @items = []
      3.times { @items << Sapwood::Item.create(name: Faker::Name.name) }
    end

    it 'will retrieve an array of items' do
      items = Sapwood::Item.query
      expect(items.class).to eq(Array)
      expect(items.first.class).to eq(Sapwood::Item)
      item_names = items.collect { |i| i.attributes[:name] }.reject(&:blank?)
      @items.each { |item| expect(item_names).to include(item.name) }
    end
    it 'accepts filter parameters' do
      item = @items.first
      items = Sapwood::Item.query(filter_by: :name, filter_value: item.name)
      expect(items.size > 0).to eq(true)
      expect(items.collect { |i| i.meta[:id] }).to match_array([item.meta[:id]])
    end
    it 'accepts ordering parameters' do
      all_items = Sapwood::Item.all
      items = Sapwood::Item.query(order_by: :name, order_in: :desc)
      expect(items.size > 0).to eq(true)
      exp_array = all_items.sort_by { |i| i.attributes[:name].to_s }.reverse.collect { |i| i.meta[:id] }
      expect(items.collect { |i| i.meta[:id] }).to match_array(exp_array)
    end
  end

  # ---------------------------------------- | Find

  describe '#find' do
    it 'will retrieve an item directly with its id' do
      new_item = Sapwood::Item.create(name: Faker::Name.name)
      item = Sapwood::Item.find(new_item.meta[:id])
      expect(item.meta[:id]).to eq(new_item.meta[:id])
      expect(item.name).to eq(new_item.name)
      expect(item.class).to eq(Sapwood::Item)
    end
  end

  # ---------------------------------------- | Attributes

  describe '#attributes, [dynamic attributes]' do
    before(:each) { authenticate_user! }
    it 'fakes an accessor for an instantiated attribute' do
      item = Sapwood::Item.new(params)
      expect(item.name).to eq(name)
      new_name = Faker::Book.name
      item.name = new_name
      expect(item.name).to eq(new_name)
    end
    it 'does not create accessors for all instances' do
      item_01 = Sapwood::Item.new({ name: Faker::Name.name })
      item_02 = Sapwood::Item.new({ title: Faker::Name.name })
      expect { item_01.title }.to raise_error(NoMethodError)
      expect { item_02.name }.to raise_error(NoMethodError)
    end
    it 'allows writing to id' do
      item = Sapwood::Item.new({ id: 123 })
      expect(item.id).to eq(123)
      item.id = 456
      expect(item.id).to eq(456)
    end
  end

  describe '#assign_attributes' do
    before(:each) { authenticate_user! }
    it 'will assign attributes on the fly' do
      item = Sapwood::Item.new
      item.assign_attributes(params)
      expect(item.name).to eq(name)
      expect(item.age).to eq(age)
      item.name = (new_name = Faker::Book.name)
      expect(item.name).to eq(new_name)
    end
  end

  # ---------------------------------------- | Data Conversion

  describe '#post_data' do
    before(:each) { authenticate_user! }
    it 'converts "_at" attributes to utc integers before save' do
      item = Sapwood::Item.new({ publish_at: (date = DateTime.current) })
      data = JSON.parse(item.send(:post_data)).deep_symbolize_keys
      expect(data[:publish_at]).to eq(date.utc.to_i)
    end
    it 'omits Sapwood meta' do
      item = Sapwood::Item.create(params)
      data = JSON.parse(item.send(:post_data)).deep_symbolize_keys
      expect(data.keys).to match_array([:name, :age])
    end
  end

  describe '#init_attributes!' do
    before(:each) { authenticate_user! }
    it 'presents "_at" attributes as datetime objects on the item' do
      item = Sapwood::Item.new({ publish_at: (date = DateTime.current.utc.to_i) })
      expect(item.publish_at).to eq(Time.at(date))
    end
  end

  # ---------------------------------------- | Database Transactions

  context '[db transactions]' do
    before(:each) { authenticate_user! }

    let(:item) { Sapwood::Item.create(params) }

    describe '#update' do
      it 'will update an existing item replacing an attribute' do
        id = item.meta[:id]
        item.update(name: (new_name = Faker::Name.name))
        item = Sapwood::Item.find(id)
        expect(item.name).to eq(new_name)
      end
      it 'will add a new attribute without deleting others' do
        id = item.meta[:id]
        old_name = item.name
        old_age = item.age
        item.update(title: (title = Faker::Book.title))
        item = Sapwood::Item.find(id)
        expect(item.title).to eq(title)
        expect(item.name).to eq(old_name)
        expect(item.age).to eq(old_age)
      end
    end

    describe '#save' do
      before(:each) { authenticate_user! }
      it 'will save an item back to the API' do
        id = item.meta[:id]
        old_age = item.age
        item.name = (new_name = Faker::Name.name)
        item.save
        item = Sapwood::Item.find(id)
        expect(item.name).to eq(new_name)
        expect(item.age).to eq(old_age)
      end
    end

    describe '#destroy' do
      before(:each) { authenticate_user! }
      it 'will delete the item' do
        response = item.destroy
        expect(response).to eq(true)
        expect { Sapwood::Item.find(item.meta[:id]) }.to raise_error(RestClient::NotFound)
      end
    end
  end

  # ---------------------------------------- | Associations

  describe '[associations]' do
    before(:each) do
      authenticate_user!
      @item_01 = Sapwood::Item.create(name: 'My First Tag')
      @item_02 = Sapwood::Item.create(name: 'My Second Tag')
    end
    it 'converts "_id" fields to associated objects on init' do
      item = Sapwood::Item.new(tag_id: @item_01.meta[:id])
      expect(item.tag_id).to eq(@item_01.meta[:id])
      expect(item.tag.class).to eq(Sapwood::Item)
      expect(item.tag.meta[:id]).to eq(@item_01.meta[:id])
    end
    it 'converts "_ids" fields to associated objects on init' do
      ids = [@item_01.meta[:id], @item_02.meta[:id]]
      item = Sapwood::Item.new(tag_ids: ids)
      expect(item.tag_ids).to eq(ids)
      expect(item.tags.first.class).to eq(Sapwood::Item)
      expect(item.tags.collect { |t| t.meta[:id] }).to match_array(ids)
    end
    it 'converts "_id" fields from API to items and makes available through "_id" attribute' do
      item = Sapwood::Item.create(tag_id: @item_01.meta[:id])
      expect(item.tag_id).to eq(@item_01.meta[:id])
      expect(item.tag.class).to eq(Sapwood::Item)
      expect(item.tag.meta[:id]).to eq(@item_01.meta[:id])
    end
    it 'converts "_ids" fields from API to items and makes available through "_ids" attribute' do
      ids = [@item_01.meta[:id], @item_02.meta[:id]]
      item = Sapwood::Item.new(tag_ids: ids)
      expect(item.tag_ids).to eq(ids)
      expect(item.tags.first.class).to eq(Sapwood::Item)
      expect(item.tags.collect { |t| t.meta[:id] }).to match_array(ids)
    end
    it 'converts a directly associated object to "_id" field' do
      item = Sapwood::Item.new(tag: @item_01)
      expect(item.tag_id).to eq(@item_01.meta[:id])
      expect(item.tag.class).to eq(Sapwood::Item)
      expect(item.tag.meta[:id]).to eq(@item_01.meta[:id])
    end
    it 'converts directly associated objects to "_ids" field' do
      item = Sapwood::Item.new(tags: [@item_01, @item_02])
      ids = [@item_01.meta[:id], @item_02.meta[:id]]
      expect(item.tag_ids).to eq(ids)
      expect(item.tags.first.class).to eq(Sapwood::Item)
      expect(item.tags.collect { |t| t.meta[:id] }).to match_array(ids)
    end
    it 'does not submit associated fields -- only its "_id" counterparts' do
      item = Sapwood::Item.new(tag: @item_01)
      data = JSON.parse(item.send(:post_data)).deep_symbolize_keys
      expect(data.keys).to include(:tag_id)
      expect(data.keys).to_not include(:tag)
    end
    it 'does not submit associated fields -- only its "_ids" counterparts' do
      item = Sapwood::Item.new(tags: [@item_01, @item_02])
      data = JSON.parse(item.send(:post_data)).deep_symbolize_keys
      expect(data.keys).to include(:tag_ids)
      expect(data.keys).to_not include(:tags)
    end
  end

end
