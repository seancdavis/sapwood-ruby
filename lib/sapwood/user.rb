module Sapwood
  class User

    attr_accessor :api_url, :token

    def initialize(options = {})
      options.symbolize_keys!
      self.api_url = Sapwood::Utils.api_url(options[:api_url])
      self.token = options[:token]
    end

  end
end
