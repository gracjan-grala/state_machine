require_relative './test_helper'

class SimpleGit
  include StateMachine

  state :up_to_date, initial: true
  state :unstaged
  state :staged
  state :ahead

  event :modify_files do
    transitions from: :up_to_date, to: :unstaged
  end

  event :add do
    transitions from: :unstaged, to: :staged
  end

  event :commit do
    transitions from: :staged, to: :ahead
  end

  event :push do
    transitions from: :ahead, to: :up_to_date
  end

  event :reset_hard_head do
    transitions from: :unstaged, to: :up_to_date
  end
end

describe 'event triggers' do
  before do
    @git = SimpleGit.new
  end

  describe 'when modifying files' do
    it 'changes state to :unstaged' do
      @git.modify_files!
      @git.current_state.must_equal :unstaged
    end
  end

  describe 'when trying to stage files' do
    it 'raises IllegalTransition' do
      assert_raises StateMachine::Errors::IllegalTransition do
        @git.add!
      end
    end
  end

  describe 'with unstaged files' do
    before do
      @git.modify_files!
    end

    describe 'when adding files' do
      it 'changes state to :staged' do
        @git.add!
        @git.current_state.must_equal :staged
      end
    end

    describe 'when hard-resetting to HEAD' do
      it 'changes state to :up_to_date' do
        @git.reset_hard_head!
        @git.current_state.must_equal :up_to_date
      end
    end
  end

  describe 'with staged files' do
    before do
      @git.modify_files!
      @git.add!
    end

    describe 'when committing' do
      it 'changes state to :ahead' do
        @git.commit!
        @git.ahead?.must_equal true
      end
    end
  end

  describe 'with new commits' do
    before do
      @git.modify_files!
      @git.add!
      @git.commit!
    end

    describe 'when pushing' do
      it 'changes state to :up_to_date' do
        @git.push!
        @git.ahead?.must_equal false
        @git.up_to_date?.must_equal true
      end
    end

    describe 'when hard-resetting to HEAD' do
      it 'raises IllegalTransition' do
        assert_raises StateMachine::Errors::IllegalTransition do
          @git.reset_hard_head!
        end
        @git.current_state.must_equal :ahead
      end
    end
  end
end
