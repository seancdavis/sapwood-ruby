module Sapwood
  class Client

    attr_reader :api_url, :api_key, :options

    def initialize(options = {})
      @options = options.symbolize_keys
      @api_url = Sapwood::Utils.api_url(options[:api_url])
      @api_key = options[:api_key]
      raise ArgumentError.new("Missing required option: api_key") if api_key.blank?
    end

    def create_item(attributes = {})
      Sapwood::Item.new({ api_url: api_url, api_key: api_key }, attributes).save
    end

    def get_items(params = {})
      request_url = Sapwood::Utils.request_url('items', api_url, params)
      response = RestClient.get(request_url, api_key_header)
      JSON.parse(response.body).map do |attrs|
        Sapwood::Item.new(options, attrs.deep_symbolize_keys)
      end
    end

    private

    def api_key_header
      Sapwood::Utils.api_key_header(api_key)
    end

  end
end
