module Sapwood
  class Collection

    attr_accessor :elements

    def initialize(elements)
      @elements = elements.map { |attrs| Sapwood::Element.new(attrs) }
    end

    def to_a
      @elements
    end

    def method_missing(method, *args, &block)
      to_a.send(method.to_s)
    end

  end
end
