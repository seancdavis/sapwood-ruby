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

    private

    def token_header
      Sapwood::Utils.token_header(token)
    end

  end
end
