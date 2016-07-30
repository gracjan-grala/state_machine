module StateMachine
  class StateMachineError < StandardError; end

  module Error
    class UndefinedState < StateMachineError; end
    class InitialStateAlreadyDefined < StateMachineError; end
    class InitialStateMissing < StateMachineError; end
  end
end
