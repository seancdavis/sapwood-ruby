module Sapwood
  class Element

    attr_accessor :attributes

    def initialize(attrs = {})
      @attributes = attrs.symbolize_keys
    end

    def method_missing(method, *args, &block)
      if @attributes.keys.include?(method.to_sym)
        return @attributes[method.to_sym]
      end
      super
    end

  end
end
