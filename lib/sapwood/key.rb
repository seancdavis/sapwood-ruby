module Sapwood
  class Key

    include Inspector

    class << self
      def all
        request_url = Utils.request_url('keys', true)
        response = RestClient.get(request_url, Utils.auth_header)
        JSON.parse(response.body).map { |attrs| Key.new(attrs) }
      end

      def find(id)
        request_url = Utils.request_url("keys/#{id}", true)
        response = RestClient.get(request_url, Utils.auth_header)
        Key.new(JSON.parse(response.body))
      end

      def create
        request_url = Utils.request_url('keys', true)
        response = RestClient.post(request_url, {}, Utils.auth_header)
        Key.new(JSON.parse(response.body))
      end
    end

    attr_reader :attributes, :created_at, :id, :updated_at, :value

    def initialize(attributes = {})
      @attributes = attributes.deep_symbolize_keys
      process_attributes!
    end

    def activate!
      Sapwood.configuration.token = nil
      Sapwood.configuration.key = value
      self
    end

    def destroy
      request_url = Utils.request_url("keys/#{id}", true)
      response = RestClient.delete(request_url, Utils.auth_header)
      Key.new(JSON.parse(response.body))
      true
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

  end
end
