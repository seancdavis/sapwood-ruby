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
      id.present? ? update : create
    end

    def create(attrs = {})
      assign_attributes(attrs)
      request(:post, 'properties')
    end

    def update(attrs = {})
      raise ArgumentError.new("Can not update property without ID") if id.blank?
      assign_attributes(attrs)
      request(:patch, "properties/#{id}")
    end

    def assign_attributes(attrs)
      attrs.deep_symbolize_keys.each { |name, value| @attributes[name] = value }
      process_attributes!
    end

    def name=(value)
      assign_attributes(name: value)
    end

    def activate!
      Sapwood.configuration.property_id = id
      self
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

    def request(request_type, request_path)
      request_url = Sapwood::Utils.request_url(request_path)
      response = RestClient.send(request_type, request_url, post_data, Sapwood::Utils.post_header)
      Sapwood::Property.new(JSON.parse(response.body))
    end

  end
end
