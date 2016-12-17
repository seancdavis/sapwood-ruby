module Sapwood
  class Property

    attr_accessor :attributes

    def initialize(attrs = {})
      attrs = JSON.parse(attrs) if attrs.is_a?(String)
      @attributes = attrs.symbolize_keys
    end

    def templates
      return [] if templates_raw.blank?
      JSON.parse(templates_raw).map { |t| Hashie::Mash.new(t) }
    end

    def json
      @attributes.to_json
    end

    def to_s
      json
    end

    def respond_to?(method, include_all = false)
      return true if @attributes.include?(method.to_sym)
      super
    end

    def method_missing(method, *args, &block)
      if @attributes.keys.include?(method.to_sym)
        value = @attributes[method.to_sym]
        if value.is_a?(Array)
          return value.map { |v| Sapwood::Element.new(v) }
        elsif value.is_a?(Hash)
          return Hashie::Mash.new(value)
        else
          return value
        end
      end
      super
    end

  end
end
