require_relative 'bowling'
require_relative 'bowling_exception'
require_relative 'frame_type'

class Frame
  include BowlingException
  include FrameType

  PINS = 10

  attr_accessor :rolls, :next_frame, :tenth_frame, :frame_number

  def initialize(frame_number)
    self.rolls = []
    self.next_frame = nil
    self.tenth_frame = false
    self.frame_number = frame_number
  end

  def frame_full?
    if tenth_frame
      tenth_frame_full?
    else
      rolls.first == 10 || rolls.size == 2
    end
  end

  def add_roll(pins)
    rolls << pins

    raise BowlingError unless valid_frame?
  end

  def valid_frame?
    if tenth_frame
      !too_many_pins_tenth_frame?
    else
      rolls.sum <= PINS
    end
  end

  # 10th frame specific logic
  def tenth_frame?
    frame_number == 10
  end

  def tenth_frame_full?
    rolls.size == 3 || (rolls.size == 2 && !qualifies_for_bonus_roll?)
  end

  def qualifies_for_bonus_roll?
    strike?(rolls) || spare?(rolls.first(2))
  end

  # TODO: Simplify (future iteration)
  def too_many_pins_tenth_frame?
    return false if rolls.all?(Game::STRIKE) && rolls.size <= 3
    return false unless rolls.size == 3

    # Spare with last roll more than 10 pins
    first_two_rolls = rolls.take(2)
    return rolls.last > PINS if spare?(first_two_rolls)

    # Strike roll 1 AND:
      # (a) Strike roll 2 AND final roll has too many pins
      # (b) Too many total pins in rolls 2 and 3
    first_roll = rolls.take(1)
    if strike?(first_roll)
      return rolls.last > PINS if strike?([rolls[1]])

      last_two_rolls = rolls.drop(1)
      return last_two_rolls.sum > PINS
    end

    false
  end
end
