module Sapwood
  class Client::Collection < Client

    def read(options = {})
      url = api_url('elements')
      response = get(url, options)
      json_to_hash(response).map { |attrs| Sapwood::Element.new(attrs) }
    end

  end
end
