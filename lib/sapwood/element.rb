module Sapwood
  class Element

    attr_accessor :attributes

    def initialize(attrs = {})
      @attributes = attrs.symbolize_keys
    end

    def respond_to?(method)
      @attributes.include?(method.to_sym)
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
