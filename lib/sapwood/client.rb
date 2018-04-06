module Sapwood
  class Client

    # TODO: Consider a configuration idiom -- https://robots.thoughtbot.com/mygem-configure-block
    #
    # This client would then be unnecessary. Instead ... ??? WHAT AM I DOING?

    attr_reader :api_url, :api_key, :token

    def initialize(options = {})
      set_attributes(options)
      validate_attributes!
    end

    # def create_item(attributes = {})
    #   Sapwood::Item.new({ api_url: api_url, api_key: api_key }, attributes).save
    # end

    # def get_items(params = {})
    #   request_url = Sapwood::Utils.request_url('items', api_url, params)
    #   response = RestClient.get(request_url, api_key_header)
    #   JSON.parse(response.body).map do |attrs|
    #     Sapwood::Item.new(options, attrs.deep_symbolize_keys)
    #   end
    # end

    # def get_item(params = {})
    #   raise ArgumentError.new("Missing required option: id") if params[:id].blank?
    #   request_url = Sapwood::Utils.request_url("items/#{params[:id]}", api_url)
    #   response = RestClient.get(request_url, api_key_header)
    #   body = JSON.parse(response.body).deep_symbolize_keys
    #   Sapwood::Item.new(options, body)
    # end

    private

    def set_attributes(options = {})
      options.symbolize_keys.each { |name, value| instance_variable_set("@#{name}", value) }
    end

    def validate_attributes!
      return if api_key.present? || token.present?
      raise ArgumentError.new("Missing required option: api_key or token")
    end

    # def api_key_header
    #   Sapwood::Utils.api_key_header(api_key)
    # end

  end
end
