module Sapwood
  class Item

    include Inspector

    class << self
      def all
        query
      end

      def query(filters = {})
        request_url = Utils.request_url('items', true, filters)
        response = RestClient.get(request_url, Utils.auth_header)
        JSON.parse(response.body).map { |attrs| Item.new(attrs) }
      end

      def find(id)
        request_url = Utils.request_url("items/#{id}", true)
        response = RestClient.get(request_url, Utils.auth_header)
        Item.new(JSON.parse(response.body))
      end

      def create(attributes = {})
        Item.new(attributes).save
      end
    end

    attr_reader :attributes

    def initialize(attrs = {})
      @attributes = attrs.deep_symbolize_keys
      init_attributes!
    end

    def assign_attributes(attrs)
      attrs.deep_symbolize_keys.each { |name, value| @attributes[name] = value }
      init_attributes!
    end

    def save
      meta[:id].present? ? update : create
    end

    def create(attrs = {})
      assign_attributes(attrs)
      request(:post, 'items')
    end

    def update(attrs = {})
      raise ArgumentError.new("Can not update item without ID") if meta[:id].blank?
      assign_attributes(attrs)
      request(:patch, "items/#{meta[:id]}")
    end

    def destroy
      raise "Can not destroy without an ID" if meta[:id].blank?
      request_url = Utils.request_url("items/#{meta[:id]}", true)
      RestClient.delete(request_url, Utils.auth_header)
      true
    end

    def meta
      attributes[:"[meta]"] || {}
    end

    def method_missing(method_name, *args, &block)
      return super unless attributes.keys.include?(method_name.to_sym)
      attributes[method_name.to_sym]
    end

    def respond_to?(method_name, include_all = false)
      return super unless attributes.keys.include?(method_name.to_sym)
      attributes.keys.include?(method_name.to_sym)
    end

    private

    def init_attributes!
      attributes.each do |name, value|
        if name.to_s.ends_with?('_at') && value.present?
          @attributes[name.to_sym] = Time.at(value)
        end
        define_singleton_method(name) { attributes[name] }
        define_singleton_method("#{name}=") { |value| @attributes[name] = value }
      end
    end

    def api_key_header
      Sapwood::Utils.api_key_header(api_key)
    end

    def post_data
      (post_data = attributes.except(:"[meta]")).each do |name, value|
        post_data[name.to_sym] = value.utc.to_i if name.to_s.ends_with?('_at')
      end
      post_data.to_json
    end

    def request(request_type, request_path)
      request_url = Utils.request_url(request_path, true)
      response = RestClient.send(request_type, request_url, post_data, Utils.auth_header)
      Item.new(JSON.parse(response.body))
    end

  end
end
