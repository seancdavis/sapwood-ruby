module Sapwood
  class << self
    def authenticate(email, password)
      request_url = Sapwood::Utils.request_url('authenticate')
      response = RestClient.post(request_url, { email: email, password: password })
      Sapwood.configuration.token = JSON.parse(response.body)['token']
    end
  end
end
