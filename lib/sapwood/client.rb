module Sapwood
  class Client

    attr_accessor :domain, :property_id, :api_key

    def initialize(options = {})
      options.each { |k,v| send("#{k.to_s}=", v) }
    end

    def get(url, options = {})
      request = RestClient.get(url, :params => base_options.merge(options))
      request.body
    end

    def elements(options = {})
      elements = json_to_hash(get(api_url('elements'), options))
      elements.map { |attrs| Sapwood::Element.new(attrs) }
    end

      private

        def base_url
          "http://#{@domain}/api/v1"
        end

        def api_url(segment)
          safe_url("#{base_url}/properties/#{@property_id}/#{segment}.json")
        end

        def base_options
          { :api_key => @api_key }
        end

        def options_to_params(options)
          return nil if options.blank?
          params = '?'
          base_options.merge(options).each { |k,v| params += "#{k}=#{v}&" }
          params.chomp('&')
        end

        def safe_url(url)
          URI.parse(URI.encode(url)).to_s
        end

        def json_to_hash(json)
          JSON.parse(json)
        end

  end

end
