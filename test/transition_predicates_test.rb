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

  event :sudo_go_to_first do
    transitions from: [:ground_floor, :second_floor], to: :first_floor, when: :building_admin?
  end

  event :sudo_go_to_second do
    transitions from: [:ground_floor, :first_floor], to: :second_floor, when: :building_admin?
  end

  def initialize(building_admin: false)
    super()
    @building_admin = building_admin
  end

  def building_admin?
    @building_admin
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

  describe 'conditional transitions' do
    describe 'on first floor' do
      before do
        @elevator.go_to_first!
      end

      it 'doesn\'t go to second floor without admin privileges' do
        @elevator.can_sudo_go_to_second?.must_equal false
      end
    end

    describe 'on second floor' do
      before do
        @elevator.go_to_second!
      end

      it 'doesn\'t go to first floor without admin privileges' do
        @elevator.can_sudo_go_to_first?.must_equal false
      end
    end

    describe 'admin elevator' do
      before do
        @admin_elevator = Elevator.new(building_admin: true)
      end

      describe 'on first floor' do
        before do
          @admin_elevator.go_to_first!
        end

        it 'can go to second floor with admin privileges' do
          @admin_elevator.can_sudo_go_to_second?.must_equal true
        end
      end

      describe 'on second floor' do
        before do
          @admin_elevator.go_to_second!
        end

        it 'can go to second floor with admin privileges' do
          @admin_elevator.can_sudo_go_to_first?.must_equal true
        end
      end
    end
  end
end
