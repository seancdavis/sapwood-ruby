module Sapwood
  class << self
    def authenticate(email, password)
      request_url = Sapwood::Utils.request_url('authenticate')
      response = RestClient.post(request_url, { email: email, password: password })
      body = JSON.parse(response.body)
      Sapwood.configuration.token = body['token']
      body
    end
  end
end
