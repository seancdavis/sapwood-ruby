module Sapwood
  class Utils

    class  << self
      def request_url(path, in_property = false, params = nil)
        params = '?' + params.map { |k,v| "#{k}=#{v}" }.join('&') if params
        prefix = in_property ? "properties/#{Sapwood.configuration.property_id}/" : ''
        if prefix.present? && Sapwood.configuration.property_id.blank?
          raise ArgumentError.new("property_id not set")
        end
        "#{Sapwood.configuration.api_url.chomp('/')}/#{prefix}#{path}#{params}"
      end

      def auth_header
        return { 'Authorization' => config.token } if config.token.present?
        return { 'API-Key' => token } if config.key.present?
      end

      private

      def config
        Sapwood.configuration
      end
    end


  end
end
