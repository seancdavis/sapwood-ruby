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
                  :auth_method,
                  :key,
                  :property_id,
                  :token

    def initialize
      @api_url = 'https://api.sapwood.org'
      @auth_method = :token
      @key = nil
      @property_id = nil
      @token = nil
    end
  end
end
