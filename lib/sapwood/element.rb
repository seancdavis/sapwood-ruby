module Sapwood
  class Element

    attr_accessor :attributes

    def initialize(attrs = {})
      @attributes = attrs.symbolize_keys
    end

    def method_missing(method, *args, &block)
      if @attributes.keys.include?(method.to_sym)
        value = @attributes[method.to_sym]
        return value.is_a?(Hash) ? Hashie::Mash.new(value) : value
      end
      super
    end

  end
end
