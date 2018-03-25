module Sapwood
  class Utils

    def self.api_url(api_url = nil)
      api_url || 'https://api.sapwood.org'
    end

    def self.request_url(path, url = nil)
      "#{api_url(url).chomp('/')}/#{path}"
    end

  end
end
