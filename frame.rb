require_relative 'bowling'
require_relative 'roll'
require_relative 'score'

# Responsible for building each frame
# Normal rules apply - frames 1 - 9
class Frame
  attr_reader :frames, :frame_number
  attr_accessor :rolls

  # Initialization and setup
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

  # Frame Management
  def build(pins)
    validate(pins)
    frames[frame_number] << pins

    frame_full? && normal_frame? and increment_frame_number
  end

  def increment_frame_number
    @frame_number += 1
  end

  def full?
    rolls.first == Game::STRIKE || rolls.size == Game::MAX_ROLLS_PER_REGULAR_FRAME
  end

  def frame_full?
    # normal_frame? ? full? : @tenth_frame.full?

    normal_frame? ? full? : TenthFrame.full?(rolls)
  end

  def tenth_frame?
    frame_number == 10
  end

  def normal_frame?
    !tenth_frame?
  end

  # Validation
  def validate(pins)
    Roll.validate(pins)

    too_many_pins?(pins) and raise Game::BowlingError, 'Frame cannot have that many pins'
  end

  def too_many_pins?(roll)
    if normal_frame?
      frames[frame_number].sum + roll > Game::PINS_PER_FRAME
    else
      TenthFrame.too_many_pins?(rolls, roll)
    end
  end

  # Helper Methods
  def strike?(roll)
    roll == Game::STRIKE
  end

  def spare?(rolls)
    rolls.sum == Game::PINS_PER_FRAME
  end

  class TenthFrame < Frame
  # Tenth frame specific stuff

    def self.too_many_pins?(rolls, roll)
      return false if rolls.all?(Game::STRIKE) && rolls.size <= 3

      rolls.size == 2 &&
        Score.strike?(rolls.first) && rolls[1] + roll > Game::PINS_PER_FRAME
    end

    def self.qualifies_for_bonus_roll?(rolls)
      rolls.size == 2 &&
      Score.strike?(rolls.first)|| Score.strike?(rolls.last) ||
          Score.spare?(rolls.first(2))
    end

    def self.full?(rolls)
      rolls.size == 3 || (rolls.size == 2 && !self.qualifies_for_bonus_roll?(rolls))
    end
  end
end
