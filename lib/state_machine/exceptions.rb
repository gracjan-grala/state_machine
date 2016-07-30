module StateMachine
  class Error < StandardError; end

  module Errors
    class UndefinedState < StateMachine::Error; end
    class InitialStateAlreadyDefined < StateMachine::Error; end
    class InitialStateMissing < StateMachine::Error; end
    class IllegalTransition < StateMachine::Error; end
  end
end
