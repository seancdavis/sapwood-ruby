module Sapwood
  class Client::Element < Client

    def read(element_id, options = {})
      url = api_url("elements/#{element_id}")
      response = get(url, options)
      Sapwood::Element.new(json_to_hash(response))
    end

    def create(payload)
      url = api_url('elements')
      response = post(url, payload)
      Sapwood::Element.new(json_to_hash(response))
    end

  end
end
