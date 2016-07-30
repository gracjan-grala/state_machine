require_relative './state_machine/class_definition'
require_relative './state_machine/exceptions'
require_relative './state_machine/helpers'
require_relative './state_machine/state'

module StateMachine
  def self.included(base)
    base.extend(ClassDefinition)
    base.instance_variable_set(:@states, {})
    base.instance_variable_set(:@initial, nil)
  end

  attr_reader :current_state

  def initialize
    self.current_state = self.class.initial
  end

  private

  def current_state=(name)
    @current_state = name.to_sym
  end
end
