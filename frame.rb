require_relative 'bowling'
require_relative 'bowling_exception'

class Frame
  include BowlingException

  STRIKE = ->(rolls) { rolls.count == 1 && rolls.sum == Game::STRIKE }  # returns true/false
  SPARE  = ->(rolls) { rolls.sum == Game::PINS && rolls.size == 2 }     # returns true/false

  FRAME_TYPE = {
    ->(rolls) { STRIKE.call(rolls) }     => :strike,
    ->(rolls) { SPARE.call(rolls) }      => :spare,
    ->(rolls) { rolls.sum < Game::PINS } => :open
  }

  private

  attr_reader :frame_number

  def initialize(frame_number)
    self.rolls = []
    self.next_frame = nil
    self.tenth_frame = false
    @frame_number = frame_number
  end

  def valid_frame?
    tenth_frame and
      not too_many_pins_tenth_frame? or
      rolls.sum <= Game::PINS
  end

  # 10th-frame-specific methods
  def qualifies_for_bonus_roll?
    tenth_frame_first_roll_strike? || tenth_frame_spare?
  end

# Helpers for too_many_pins_tenth_frame?
  def tenth_frame_spare?
    SPARE.call(rolls.first(2))
  end

  def tenth_frame_first_roll_strike?
    STRIKE.call([rolls.first])
  end

  def tenth_frame_second_roll_strike?
    STRIKE.call([rolls[1]])
  end

  def too_many_pins_tenth_frame?
    return false unless rolls.size == 3
    return false if rolls.all?(Game::STRIKE)

    # Scenarios with too many pins:
    #   Spare with last roll more than 10 pins
    #   Strike roll 1 AND:
    #     (a) Strike roll 2 where roll 3 has more than 10 pins
    #     (b) Rolls 2 and 3 total more than 10 pins

    roll_quantity = if tenth_frame_first_roll_strike?
                      tenth_frame_second_roll_strike? ? 1 : 2
                    elsif tenth_frame_spare?
                      1
                    end

    rolls.last(roll_quantity).sum > Game::PINS
  end

  public

  attr_accessor :rolls, :next_frame, :tenth_frame, :score_as

  # Standard frame methods
  def frame_full?
    tenth_frame_full? || standard_frame_full?
  end

  def standard_frame_full?
    return false if tenth_frame?

    rolls.first == 10 || rolls.size == 2
  end

  def add_roll(pins)
    rolls << pins

    raise BowlingError, 'Pins must not exceed %d pins' % [Game::PINS] unless valid_frame?
  end

  # Sets attribute score_as to :strike, :spare, or :open
  def frame_type
    FRAME_TYPE.each do |check_score_type, score_type|
      self.score_as = score_type if matching_frame_type?(rolls, check_score_type)
    end
  end

  def matching_frame_type?(rolls, check_score_type)
    check_score_type.call(rolls)
  end

  # 10th-frame-specific methods
  def tenth_frame?
    frame_number == 10
  end

  def tenth_frame_full?
    return false unless tenth_frame?

    rolls.size == 3 || rolls.size == 2 && !qualifies_for_bonus_roll?
  end

end
