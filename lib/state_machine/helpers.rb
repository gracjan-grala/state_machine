module StateMachine
  module Helpers
    def self.coerce_array(obj)
      obj.is_a?(Array) ? obj : Array[obj]
    end

    def self.invoke_code_on_caller(code, caller)
      return code.call if code.is_a?(Proc)
      caller.send(code) if code.is_a?(Symbol)
    end
  end
end
