module Sapwood
  class Property

    attr_accessor :api_url, :master_key, :name, :id

    def initialize(options = {}, attributes = {})
      options.symbolize_keys!
      self.api_url = Sapwood::Utils.api_url(options[:api_url])
      self.master_key = options[:master_key]

      attributes.symbolize_keys!
      self.id = attributes[:id]
      self.name = attributes[:name]
    end

    def create_key(attributes = {})
      request_url = Sapwood::Utils.request_url('keys', api_url)
      response = RestClient.post(request_url, attributes, master_key_header)
      body = JSON.parse(response.body).deep_symbolize_keys
      Sapwood::Key.new(body)
    end

    def get_keys
      request_url = Sapwood::Utils.request_url('keys', api_url)
      response = RestClient.get(request_url, master_key_header)
      body = JSON.parse(response.body).map do |attrs|
        Sapwood::Key.new(attrs.deep_symbolize_keys)
      end
    end

    def get_key(options = {})
      raise ArgumentError.new("Missing required option: id") if options[:id].blank?
      request_url = Sapwood::Utils.request_url("keys/#{options[:id]}", api_url)
      response = RestClient.get(request_url, master_key_header)
      body = JSON.parse(response.body).deep_symbolize_keys
      Sapwood::Key.new(body)
    end

    def delete_key(options = {})
      raise ArgumentError.new("Missing required option: id") if options[:id].blank?
      request_url = Sapwood::Utils.request_url("keys/#{options[:id]}", api_url)
      response = RestClient.delete(request_url, master_key_header)
      true
    end

    private

    def master_key_header
      Sapwood::Utils.master_key_header(master_key)
    end

  end
end
