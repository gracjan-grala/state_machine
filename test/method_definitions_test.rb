require_relative './test_helper'

class ExampleStateMachine
  include StateMachine

  state :on
  state :off, initial: true

  event :turn_on do
    transitions from: :off, to: :on
  end

  event :turn_off do
    transitions from: :on, to: :off
  end
end

describe ExampleStateMachine do
  before do
    @state_machine = ExampleStateMachine.new
  end

  describe 'initialized example state machine' do
    it 'responds to #current_state' do
      @state_machine.must_respond_to :current_state
    end

    it 'responds to #on?' do
      @state_machine.must_respond_to :on?
    end

    it 'responds to #off?' do
      @state_machine.must_respond_to :off?
    end

    it 'responds to #can_turn_on?' do
      @state_machine.must_respond_to :can_turn_on?
    end

    it 'responds to #can_turn_off?' do
      @state_machine.must_respond_to :can_turn_off?
    end

    it 'responds to #turn_on!' do
      @state_machine.must_respond_to :turn_on!
    end

    it 'responds to #turn_off!' do
      @state_machine.must_respond_to :turn_off!
    end
  end
end
