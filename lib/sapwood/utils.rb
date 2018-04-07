module Sapwood
  class Utils

    class  << self
      # def api_url(api_url = nil)
      #   api_url || 'https://api.sapwood.org'
      # end

      def request_url(path, in_property = false, params = nil)
        params = '?' + params.map { |k,v| "#{k}=#{v}" }.join('&') if params
        prefix = in_property ? "properties/#{Sapwood.configuration.property_id}/" : ''
        if prefix.present? && Sapwood.configuration.property_id.blank?
          raise ArgumentError.new("property_id not set")
        end
        "#{Sapwood.configuration.api_url.chomp('/')}/#{prefix}#{path}#{params}"
      end

      def get_header
        return { 'Authorization' => config.token } if config.token.present?
        return { 'API-Key' => token } if config.key.present?
      end

      def post_header
        get_header.merge(content_type: :json, accept: :json)
      end

      private

      def config
        Sapwood.configuration
      end
    end


  end
end
