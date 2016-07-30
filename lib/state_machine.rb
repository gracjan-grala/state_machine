require_relative './state_machine/callback'
require_relative './state_machine/class_definition'
require_relative './state_machine/event'
require_relative './state_machine/exceptions'
require_relative './state_machine/helpers'
require_relative './state_machine/state'

module StateMachine
  def self.included(base)
    base.extend(ClassDefinition)
    base.instance_variable_set(:@states, {})
    base.instance_variable_set(:@events, {})
    base.instance_variable_set(:@initial, nil)
    base.instance_variable_set(:@before_callbacks, [])
    base.instance_variable_set(:@after_callbacks, [])
  end

  attr_reader :current_state

  def initialize
    unless self.class.initial
      raise Errors::InitialStateMissing, 'Initial state has not been defined'
    end
    super
    self.current_state = self.class.initial
  end

  private

  def invoke_callbacks(collection, from, to)
    collection.each { |callback| callback.invoke_if_matches(from: from, to: to, caller: self) }
  end

  def validate_transition(event_name, original_state, destination_state)
    unless send("can_#{event_name}?")
      raise Errors::IllegalTransition,
        "Event #{event_name} doesn't allow transition
        from #{original_state} to #{destination_state}"
    end
  end

  def current_state=(name)
    @current_state = name.to_sym
  end
end
