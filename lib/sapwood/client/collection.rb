module Sapwood
  class Client::Collection < Client

    def read(options = {})
      url = api_url('elements')
      response = get(url, options)
      Sapwood::Collection.new(json_to_hash(response))
    end

  end
end
