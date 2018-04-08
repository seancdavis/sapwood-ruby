module Sapwood
  class User

    include Inspector

    class << self
      def all
        request_url = Utils.request_url('users', true)
        response = RestClient.get(request_url, Utils.auth_header)
        JSON.parse(response.body).map { |attrs| User.new(attrs) }
      end

      def find(id)
        request_url = Utils.request_url("users/#{id}", true)
        response = RestClient.get(request_url, Utils.auth_header)
        User.new(JSON.parse(response.body))
      end

      def create(params = {})
        request_url = Utils.request_url('users', true)
        response = RestClient.post(request_url, params, Utils.auth_header)
        User.new(JSON.parse(response.body))
      end
    end

    attr_reader :attributes, :created_at, :email, :id, :updated_at

    def initialize(attributes = {})
      @attributes = attributes.deep_symbolize_keys
      process_attributes!
    end

    def destroy
      request_url = Utils.request_url("users/#{id}", true)
      response = RestClient.delete(request_url, Utils.auth_header)
      User.new(JSON.parse(response.body))
      true
    end

    private

    def process_attributes!
      attributes.each do |name, value|
        if name.to_s.ends_with?('_at') && value.present? && value.is_a?(Integer)
          @attributes[name.to_sym] = Time.at(value)
        end
        instance_variable_set("@#{name}", @attributes[name.to_sym])
      end
    end

  end
end
