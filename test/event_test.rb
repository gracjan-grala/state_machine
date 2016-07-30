require_relative './test_helper'

describe StateMachine::Event do
  describe 'constructor' do
    it 'raises InvalidDestinationState when :to is a collection' do
      assert_raises StateMachine::Errors::InvalidDestinationState do
        StateMachine::Event.new(from: :a, to: [:b, :c])
      end
    end

    it 'accepts a collection as :from parameter' do
      assert_no_error do
        StateMachine::Event.new(from: [:a, :b], to: :c)
      end
    end
  end

  describe 'transition legality check' do
    before do
      @event = StateMachine::Event.new(from: [:a, :b], to: :d)
    end

    it 'allows transition from :a to :d' do
      @event.transition?(from: :a, to: :d).must_equal true
    end

    it 'refuses transition from :d to :b' do
      @event.transition?(from: :d, to: :b).must_equal false
    end
  end

  describe 'legality check with guard clause' do
    describe 'given as symbol' do
      it 'sends truthy method to the caller' do
        caller = Minitest::Mock.new
        event = StateMachine::Event.new(from: [:a, :b], to: :d, guard: :some_method)
        caller.expect(:some_method, true)

        event.transition?(from: :a, to: :d, caller: caller).must_equal true
      end

      it 'sends falsy method to the caller' do
        caller = Minitest::Mock.new
        event = StateMachine::Event.new(from: [:a, :b], to: :d, guard: :some_method)
        caller.expect(:some_method, nil)

        event.transition?(from: :b, to: :d, caller: caller).must_equal false
      end
    end

    describe 'given as lambda' do
      it 'calls a truthy lambda with the caller as argument' do
        something = :something
        event = StateMachine::Event.new(from: :a, to: :d, guard: -> { something == :something })

        event.transition?(from: :a, to: :d, caller: @caller).must_equal true
      end

      it 'calls a falsy lambda with the caller as argument' do
        @something = :something
        event = StateMachine::Event.new(from: [:a, :b], to: :d, guard: -> { @something == 1 })

        event.transition?(from: :a, to: :d, caller: @caller).must_equal false
      end
    end
  end
end
