module Sapwood
  class Item

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
        item = Item.new(attributes)
        item.save
        item
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
      attributes.clone.each do |name, value|
        @attributes[name.to_sym] = Time.at(value) if name.to_s.ends_with?('_at') && value.present?

        if name.to_s.ends_with?('_id')
          assoc_name = name.to_s.chomp('_id').to_sym
          if attributes[assoc_name].blank? || attributes[assoc_name].meta[:id].to_i != value.to_i
            @attributes[assoc_name] = Sapwood::Item.find(value)
          end
        end

        if value.is_a?(Hash) && value[:"[meta]"].present?
          value = Sapwood::Item.new(value)
          @attributes[name.to_sym] = value
        end

        if value.is_a?(Sapwood::Item) && ! attributes.keys.include?(:"#{name}_id")
          @attributes[:"#{name}_id"] = value.meta[:id]
        end

        if name.to_s.ends_with?('_ids')
          assoc_name = name.to_s.chomp('_ids').pluralize.to_sym
          current_attr = attributes[assoc_name]
          if current_attr.blank? || current_attr.collect { |i| i.meta[:id].to_i }.sort != value.map(&:to_i).sort
            @attributes[assoc_name] = value.map { |id| Sapwood::Item.find(id) }
          end
        end

        if value.is_a?(Array) && value.first.is_a?(Hash) && value.first[:"[meta]"].present?
          value = value.map { |id| Sapwood::Item.new(id.to_i) }
          @attributes[name.to_sym] = value
        end

        if value.is_a?(Array) && value.first.is_a?(Sapwood::Item) && ! attributes.keys.include?(:"#{name}_ids")
          @attributes[:"#{name.to_s.singularize}_ids"] = value.map { |i| i.meta[:id] }
        end

        define_singleton_method(name) { attributes[name] }
        define_singleton_method("#{name}=") { |value| @attributes[name] = value }
      end
    end

    def post_data
      post_data = attributes.except(:"[meta]")
      post_data.clone.each do |name, value|
        post_data[name.to_sym] = value.utc.to_i if name.to_s.ends_with?('_at')

        if value.is_a?(Sapwood::Item)
          post_data[:"#{name}_id"] = value.meta[:id].to_i
          post_data.except!(name.to_sym)
        end

        if value.is_a?(Array) && value.first.is_a?(Sapwood::Item)
          post_data[:"#{name.to_s.singularize}_ids"] = value.collect { |i| i.meta[:id].to_i }
          post_data.except!(name.to_sym)
        end
      end
      post_data.to_json
    end

    def request(request_type, request_path)
      request_url = Utils.request_url(request_path, true)
      response = RestClient.send(request_type, request_url, post_data, Utils.auth_header)
      @attributes = JSON.parse(response.body).deep_symbolize_keys
      init_attributes!
      true
    end

  end
end
