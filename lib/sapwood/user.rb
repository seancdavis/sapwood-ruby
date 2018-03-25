module Sapwood
  class User

    attr_accessor :api_url, :token

    def initialize(options = {})
      options.symbolize_keys!
      self.api_url = Sapwood::Utils.api_url(options[:api_url])
      self.token = options[:token]
    end

    def create_property(attributes = {})
      request_url = Sapwood::Utils.request_url('properties', api_url)
      response = RestClient.post(request_url, attributes, token_header)
      body = JSON.parse(response.body).deep_symbolize_keys
      options = { api_url: api_url, master_key: body[:master_key][:value] }
      Sapwood::Property.new(options, body[:property])
    end

    def get_properties
      request_url = Sapwood::Utils.request_url('properties', api_url)
      response = RestClient.get(request_url, token_header)
      body = JSON.parse(response.body).map do |p|
        attrs = p.deep_symbolize_keys
        options = { api_url: api_url, master_key: attrs[:master_key][:value] }
        Sapwood::Property.new(options, attrs[:property])
      end
    end

    def get_property(options = {})
      raise ArgumentError.new("Missing required option: id") if options[:id].blank?
      request_url = Sapwood::Utils.request_url("properties/#{options[:id]}", api_url)
      response = RestClient.get(request_url, token_header)
      body = JSON.parse(response.body).deep_symbolize_keys
      options = { api_url: api_url, master_key: body[:master_key][:value] }
      Sapwood::Property.new(options, body[:property])
    end

    private

    def token_header
      Sapwood::Utils.token_header(token)
    end

  end
end
