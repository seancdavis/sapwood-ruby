module Sapwood
  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  class Configuration
    attr_accessor :api_url,
                  :key,
                  :property_id,
                  :token

    def api_url
      @api_url ||= 'https://api.sapwood.org'
    end
  end
end
