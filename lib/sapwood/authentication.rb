module Sapwood
  class Authentication

    def self.get_token(options = {})
      api_url = Sapwood::Utils.api_url(options[:api_url])
      request_url = Sapwood::Utils.request_url('authenticate', options[:api_url])
      params = { email: options[:email], password: options[:password] }
      response = RestClient.post(request_url, params)
      Sapwood::User.new(JSON.parse(response.body).merge(api_url: api_url))
    end

  end
end
