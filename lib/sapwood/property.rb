module Sapwood
  class Property

    class << self
      def all
        request_url = Sapwood::Utils.request_url('properties')
        response = RestClient.get(request_url, Sapwood::Utils.get_header)
        JSON.parse(response.body).map { |attrs| Property.new(attrs) }
      end

      def where(attributes = {})
        properties = all
        attributes.each { |k, v| properties.select! { |p| p.send(k) == v } }
        properties
      end

      def find_by(attributes = {})
        where(attributes).first
      end

      def create(attributes = {})
        Sapwood::Property.new(attributes).save
      end
    end

    attr_reader :attributes, :created_at, :id, :name, :updated_at

    def initialize(attributes = {})
      @attributes = attributes.deep_symbolize_keys
      process_attributes!
    end

    def save
      return create! if id.blank?
      update!
    end

    def assign_attributes(attrs)
      attrs.deep_symbolize_keys.each { |name, value| @attributes[name] = value }
      process_attributes!
    end

    def name=(value)
      assign_attributes(name: value)
    end

    private

    def process_attributes!
      attributes.each do |name, value|
        if name.to_s.ends_with?('_at') && value.present? && value.is_a?(Integer)
          @attributes[name.to_sym] = Time.at(value)
        end
        instance_variable_set("@#{name}", @attributes[name.to_sym])
      end
    end

    def post_data
      attributes.slice(:name)
    end

    def create!
      post('properties')
    end

    def update!
      raise ArgumentError.new("Can not update property without ID") if id.blank?
      post("properties/#{id}")
    end

    def post(request_path)
      request_url = Sapwood::Utils.request_url(request_path)
      response = RestClient.post(request_url, post_data, Sapwood::Utils.post_header)
      Sapwood::Property.new(JSON.parse(response.body))
    end

    # ---------------------------------------- | ...

    # def create_key(attributes = {})
    #   request_url = Sapwood::Utils.request_url('keys', api_url)
    #   response = RestClient.post(request_url, attributes, master_key_header)
    #   body = JSON.parse(response.body).deep_symbolize_keys
    #   Sapwood::Key.new(body)
    # end

    # def get_keys
    #   request_url = Sapwood::Utils.request_url('keys', api_url)
    #   response = RestClient.get(request_url, master_key_header)
    #   body = JSON.parse(response.body).map do |attrs|
    #     Sapwood::Key.new(attrs.deep_symbolize_keys)
    #   end
    # end

    # def get_key(options = {})
    #   raise ArgumentError.new("Missing required option: id") if options[:id].blank?
    #   request_url = Sapwood::Utils.request_url("keys/#{options[:id]}", api_url)
    #   response = RestClient.get(request_url, master_key_header)
    #   body = JSON.parse(response.body).deep_symbolize_keys
    #   Sapwood::Key.new(body)
    # end

    # def delete_key(options = {})
    #   raise ArgumentError.new("Missing required option: id") if options[:id].blank?
    #   request_url = Sapwood::Utils.request_url("keys/#{options[:id]}", api_url)
    #   response = RestClient.delete(request_url, master_key_header)
    #   true
    # end

    # private

    # def master_key_header
    #   Sapwood::Utils.master_key_header(master_key)
    # end

  end
end
