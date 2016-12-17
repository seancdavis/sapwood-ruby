module Sapwood
  class Client::Property < Client

    def read
      response = get(safe_url("#{base_url}/properties/#{@property_id}.json"))
      Sapwood::Property.new(json_to_hash(response))
    end

  end
end
