module Sapwood
  class Client

    attr_accessor :api_url, :api_key

    def initialize(options = {})
      options.symbolize_keys!
      self.api_url = Sapwood::Utils.api_url(options[:api_url])
      self.api_key = options[:api_key]
      raise ArgumentError.new("Missing required option: api_key") if options[:api_key].blank?
    end

    def create_item(attributes = {})
      Sapwood::Item.new({ api_url: api_url, api_key: api_key }, attributes).save
    end

  end
end
