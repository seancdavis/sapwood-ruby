module Sapwood
  class Item

    attr_reader :api_url, :api_key, :options, :attributes

    def initialize(opts = {}, attrs = {})
      @options = opts.symbolize_keys
      @attributes = attrs.symbolize_keys.reverse_merge(id: nil, created_at: nil, updated_at: nil)

      @api_url = Sapwood::Utils.api_url(options[:api_url])
      @api_key = options[:api_key]
      raise ArgumentError.new("Missing required option: api_key") if api_key.blank?

      init_attributes!
    end

    def assign_attributes(attrs)
      attrs.deep_symbolize_keys.each { |name, value| @attributes[name] = value }
      init_attributes!
    end

    def save
      return create! if id.blank?
      update!
    end

    def update(attrs = {})
      assign_attributes(attrs)
      update!
    end

    def destroy
      destroy!
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
        define_singleton_method(name) do
          attributes[name]
        end
        next if %w{id created_at updated_at}.include?(name.to_s)
        define_singleton_method("#{name}=") do |value|
          @attributes[name] = value
        end
      end
    end

    def api_key_header
      Sapwood::Utils.api_key_header(api_key)
    end

    def post_data
      (post_data = attributes.except(:id, :created_at, :updated_at)).each do |name, value|
        post_data[name.to_sym] = value.utc.to_i if name.to_s.ends_with?('_at')
      end
      post_data.to_json
    end


    def post_data_header
      api_key_header.merge(content_type: :json, accept: :json)
    end

    def create!
      request!(:post, Sapwood::Utils.request_url('items', api_url))
    end

    def update!
      raise "Can not update without an id." if id.blank?
      request!(:patch, Sapwood::Utils.request_url("items/#{id}", api_url))
    end

    def destroy!
      raise "Can not destroy without an id." if id.blank?
      RestClient.delete(Sapwood::Utils.request_url("items/#{id}", api_url), api_key_header)
      true
    end

    def request!(type, request_url)
      response = RestClient.send(type, request_url, post_data, post_data_header)
      Sapwood::Item.new(@options, JSON.parse(response.body))
    end

  end
end
