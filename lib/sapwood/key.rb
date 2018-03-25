module Sapwood
  class Key

    attr_accessor :id, :value

    def initialize(attributes = {})
      attributes.symbolize_keys!
      self.id = attributes[:id]
      self.value = attributes[:value]
    end

  end
end
