module StateMachine
  module Helpers
    def self.coerce_array(obj)
      obj.is_a?(Array) ? obj : Array[obj]
    end
  end
end
