require_relative './test_helper'

describe 'state machine definition' do
  describe 'multiple initial states' do
    it 'raises InitialStateAlreadyDefined' do
      assert_raises StateMachine::Errors::InitialStateAlreadyDefined do
        Class.new do
          include StateMachine

          state :standing, initial: true
          state :walking, initial: true
        end
      end
    end
  end

  describe 'with no initial state' do
    it 'raises InitialStateMissing' do
      assert_raises StateMachine::Errors::InitialStateMissing do
        Class.new do
          include StateMachine

          state :standing
          state :walking
        end.new
      end
    end
  end

  describe 'given transition from undefined state' do
    it 'raises UndefinedState' do
      assert_raises StateMachine::Errors::UndefinedState do
        Class.new do
          include StateMachine

          state :defined, initial: true

          event :walk do
            transitions from: :something, to: :defined
          end
        end
      end
    end
  end

  describe 'given transition to undefined state' do
    it 'raises UndefinedState' do
      assert_raises StateMachine::Errors::UndefinedState do
        Class.new do
          include StateMachine

          state :defined, initial: true

          event :walk do
            transitions from: :defined, to: :something
          end
        end
      end
    end
  end

  describe 'full correct state machine definition' do
    it 'raises no errors' do
      assert_no_error do
        Class.new do
          include StateMachine

          state :standing, initial: true
          state :walking
          state :running

          event :walk do
            transitions from: :standing, to: :walking
          end

          event :run do
            transitions from: [:standing, :walking], to: :running
          end

          event :hold do
            transitions from: [:walking, :running], to: :standing
          end
        end
      end
    end
  end
end
