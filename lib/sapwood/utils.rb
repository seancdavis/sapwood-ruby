module Sapwood
  class Utils

    # def self.api_url(api_url = nil)
    #   api_url || 'https://api.sapwood.org'
    # end

    def self.request_url(path, url = nil, params = nil)
      params = '?' + params.map { |k,v| "#{k}=#{v}" }.join('&') if params
      "#{Sapwood.configuration.api_url.chomp('/')}/#{path}#{params}"
    end

    # def self.token_header(token)
    #   { 'Authorization' => token }
    # end

    # def self.api_key_header(token)
    #   { 'API-Key' => token }
    # end

  end
end
