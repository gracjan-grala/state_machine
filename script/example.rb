class ExampleStateMachine
  include StateMachine
  attr_reader :confirmation, :push_counter

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

  before_transition :show_confirmation, from: :unstaged, to: :up_to_date
  after_transition :increment_push_counter, from: :ahead

  def show_confirmation
    @confirmation.show!
  end

  def increment_push_counter
    @push_counter += 1
  end

  def initialize
    super
    @confirmation = MiniTest::Mock.new
    @push_counter = 0
  end
end
