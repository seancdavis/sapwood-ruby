module Sapwood
  module Inspector
    def inspect
      "#<#{self.class.name}:#{self.object_id}>"
    end
  end
end
