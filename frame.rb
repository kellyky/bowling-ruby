require_relative 'bowling'
require_relative 'roll'
require_relative 'score'

# Responsible for building each frame
class Frame

  attr_reader :frames, :frame_number
  attr_accessor :rolls

  # private
  def initialize
    @frame_number = 1
    @frames = {
       1 => [],
       2 => [],
       3 => [],
       4 => [],
       5 => [],
       6 => [],
       7 => [],
       8 => [],
       9 => [],
      10 => [],
    }

    self.rolls = rolls
  end

  def rolls
    frames[frame_number]
  end

  def build(pins)
    validate(pins)

    frames[frame_number] << pins

    frame_full? && !tenth_frame? and increment_frame_number
  end

  def validate(pins)
    Roll.validate(pins)

    too_many_pins?(pins) and raise Game::BowlingError, 'Frame cannot have that many pins'
  end

  def too_many_pins?(roll)
    if normal_frame?
      too_many_pins_normal_frame?(roll)
    else
      too_many_pins_tenth_frame?(roll)
    end
  end

  def too_many_pins_tenth_frame?(roll)
    return false if rolls.all?(Game::STRIKE) && rolls.size <= 3

    rolls.size == 2 &&
      strike?(rolls.first) && rolls[1] + roll > Game::PINS_PER_FRAME
  end

  # TODO: check this one - aptly named? redundant?
  def too_many_pins_normal_frame?(roll)
    frames[frame_number].sum + roll > Game::PINS_PER_FRAME
  end

  def frame_full?
    tenth_frame? ? frame_ten_full? : earlier_frame_full?
  end

  def tenth_frame?
    frame_number == 10
  end

  def normal_frame?
    !tenth_frame?
  end

  def increment_frame_number
    @frame_number += 1
  end

  def qualifies_for_bonus_roll?
    tenth_frame? && rolls.size == 2 &&
      strike?(rolls.first) || strike?(rolls.last) ||
        spare?(rolls.first(2))
  end

  def frame_ten_full?
    rolls.size == 3 || (rolls.size == 2 && !qualifies_for_bonus_roll?)
  end

  def strike?(roll)
    roll == Game::STRIKE
  end

  def spare?(rolls)
    rolls.sum == Game::PINS_PER_FRAME
  end

  def earlier_frame_full?
    rolls.first == Game::STRIKE || rolls.size == Game::MAX_ROLLS_PER_REGULAR_FRAME
  end
end
