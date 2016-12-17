module Sapwood
  class Collection

    attr_accessor :elements

    def initialize(elements)
      @elements = elements.map { |attrs| Sapwood::Element.new(attrs) }
    end

    def to_a
      @elements
    end

  end
end
