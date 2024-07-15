require_relative 'bowling'
require_relative 'score'

# Responsible for building each frame
class Frame

  public

  attr_reader :frames, :frame_number

  def build(roll)
    too_many_pins?(roll) and raise Game::BowlingError, 'Too many pins'

    add_roll_to_frame(roll)

    frame_full? && !tenth_frame? and increment_frame_number
  end

  def qualifies_for_bonus_roll?
    rolls = frames[frame_number]

    tenth_frame? && rolls.size == 2 &&
      strike?(rolls.first) || strike?(rolls.last) ||
        spare?(rolls.first(2))
  end

  def frame_ten_full?(rolls)
    rolls.size == 3 || (rolls.size == 2 && !qualifies_for_bonus_roll?)
  end

  private

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
  end

  def strike?(roll)
    roll == Game::STRIKE
  end

  def spare?(rolls)
    rolls.sum == Game::PINS_PER_FRAME
  end

  def increment_frame_number
    @frame_number += 1
  end

  def add_roll_to_frame(roll)
    frames[frame_number] << roll
  end

  def frame_full?
    rolls = frames[frame_number]

    tenth_frame? ? frame_ten_full?(rolls) : earlier_frame_full?(rolls)
  end

  def tenth_frame?
    frame_number == 10
  end

  def earlier_frame_full?(rolls)
    rolls.first == Game::STRIKE || rolls.size == Game::MAX_ROLLS_PER_REGULAR_FRAME
  end

  def valid_pins_per_frame?(roll)
    frames[frame_number].sum + roll > Game::PINS_PER_FRAME
  end

  def valid_pins_per_roll(roll)
    roll <= Game::PINS_PER_FRAME
  end

  def too_many_pins?(roll)
    valid_pins_per_roll(roll) &&
      tenth_frame? ? too_many_pins_tenth_frame?(roll) : valid_pins_per_frame?(roll)
  end

  def valid_tenth_frame_rolls?(rolls)
    rolls.all?(Game::STRIKE) && rolls.size <= 3
  end

  def valid_pins_tenth_frame?(rolls)
    first_roll second_roll, third_roll = rolls
    second_roll + third_roll <= Game::PINS_PER_FRAME
  end

  def too_many_pins_tenth_frame?(roll)
    rolls = frames[frame_number]

    return false if valid_tenth_frame_rolls?(rolls)

    rolls.size == 2 &&
      strike?(rolls.first) && rolls[1] + roll > Game::PINS_PER_FRAME
  end
end
