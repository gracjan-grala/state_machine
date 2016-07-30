require_relative './test_helper'

describe StateMachine::Callback do
  describe '#matches?' do
    describe 'given both matching parameters' do
      it 'matches' do
        StateMachine::Callback.new(from: :a, to: :b, code: -> {})
          .matches?(from: :a, to: :b).must_equal true
      end
    end

    describe 'given matching :from parameter' do
      it 'matches' do
        StateMachine::Callback.new(from: :a, code: -> {})
          .matches?(from: :a, to: :b).must_equal true
      end
    end

    describe 'given matching :to parameter' do
      it 'matches' do
        StateMachine::Callback.new(to: :b, code: -> {})
          .matches?(from: :a, to: :b).must_equal true
      end
    end

    describe 'given non-matching :to parameter' do
      it 'doesn\'t match' do
        StateMachine::Callback.new(from: :a, to: :c, code: -> {})
          .matches?(from: :a, to: :b).must_equal false
      end
    end

    describe 'given non-matching :from parameter' do
      it 'doesn\'t match' do
        StateMachine::Callback.new(from: :g, to: :b, code: -> {})
          .matches?(from: :a, to: :b).must_equal false
      end
    end
  end

  describe 'invoking code' do
    describe 'with method symbol' do
      before do
        @caller = MiniTest::Mock.new
      end

      it 'invokes the callback if matching transition parameters provided' do
        @caller.expect(:my_method, 4)

        StateMachine::Callback.new(to: :b, code: :my_method)
          .invoke_if_matches(from: :irrelevant, to: :b, caller: @caller).must_equal 4
      end

      it 'doesn\'t invoke the callback if wrong transition parameters provided' do
        StateMachine::Callback.new(to: :b, code: :my_method)
          .invoke_if_matches(from: :irrelevant, to: :other, caller: @caller).must_be_nil
      end
    end

    describe 'with lambda' do
      before do
        @caller = MiniTest::Mock.new
        @lambda = -> { @caller.ping }
      end

      it 'invokes the callback if matching transition parameters provided' do
        @caller.expect(:ping, :pong)

        StateMachine::Callback.new(to: :b, code: @lambda)
          .invoke_if_matches(from: :irrelevant, to: :b, caller: nil).must_equal :pong
      end

      it 'doesn\'t invoke the callback if wrong transition parameters provided' do
        StateMachine::Callback.new(to: :b, code: @lambda)
          .invoke_if_matches(from: :irrelevant, to: :other, caller: nil).must_be_nil
      end
    end
  end
end
