module Sapwood
  class Client

    attr_accessor :domain, :property_id, :api_key, :ssl

    def initialize(options = {})
      options.each { |k,v| send("#{k.to_s}=", v) }
      ssl = false if ssl.nil?
    end

    def property
      Sapwood::Client::Property.new(current_options)
    end

    def element
      Sapwood::Client::Element.new(current_options)
    end

    def collection
      Sapwood::Client::Collection.new(current_options)
    end

    private

      def current_options
        {
          :domain => domain,
          :property_id => property_id,
          :api_key => api_key,
          :ssl => ssl
        }
      end

      def get(url, options = {})
        request = RestClient.get(url, :params => base_options.merge(options))
        request.body
      end

      def post(url, payload)
        request = RestClient.post(url, base_options.merge(payload))
        request.body
      end

      def base_url
        "http#{'s' if ssl == true}://#{@domain}/api/v1"
      end

      def api_url(segment)
        safe_url("#{base_url}/properties/#{@property_id}/#{segment}.json")
      end

      def base_options
        { :api_key => @api_key }
      end

      def safe_url(url)
        URI.parse(URI.encode(url)).to_s
      end

      def json_to_hash(json)
        JSON.parse(json)
      end

  end
end
