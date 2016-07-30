require 'pry'
require_relative './test_helper'

class Elevator
  include StateMachine

  state :ground_floor, initial: true
  state :first_floor
  state :second_floor

  event :go_to_ground do
    transitions from: [:first_floor, :second_floor], to: :ground_floor
  end

  event :go_to_first do
    transitions from: :ground_floor, to: :first_floor
  end

  event :go_to_second do
    transitions from: :ground_floor, to: :second_floor
  end
end

describe 'transition predicates' do
  before do
    @elevator = Elevator.new
  end

  describe 'new Elevator' do
    it 'is on ground floor' do
      @elevator.current_state.must_equal :ground_floor
    end

    it 'can go to second floor' do
      @elevator.can_go_to_second?.must_equal true
    end

    it 'cannot go to ground floor' do
      @elevator.can_go_to_ground?.must_equal false
    end
  end

  describe 'Elevator on first floor' do
    before do
      @elevator.go_to_first!
    end

    it 'can go to the ground floor' do
      @elevator.can_go_to_ground?.must_equal true
    end

    it 'cannot go to second floor' do
      @elevator.can_go_to_second?.must_equal false
    end

    it 'cannot go to first floor' do
      @elevator.can_go_to_first?.must_equal false
    end
  end
end
