require_relative 'roll'

# Responsible for building each frame
# Normal rules apply - frames 1 - 9
class Frame
  include BowlingExeption
  include FrameType

  PINS = 10

  private

  attr_accessor :tenth_frame
  attr_writer :frame_number

  # Initialization and setup
  def initialize
    self.frame_number = 1
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

  def rolls
    frames[frame_number]
  end

  def make_tenth_frame_builder
    self.tenth_frame = TenthFrame.new(rolls)
  end

  def increment_frame_number
    @frame_number += 1
  end

  def frame_full?
    if normal_frame?
      rolls.first == Game::STRIKE || rolls.size == Game::MAX_ROLLS_PER_REGULAR_FRAME
    else
      tenth_frame.full?
    end
  end

  def normal_frame?
    !tenth_frame?
  end

  # Validation
  def validate(pins)
    Roll.validate(pins)

    normal_frame? and too_many_pins?(pins) and too_many_pins_error
  end

  def too_many_pins?(roll)
    frames[frame_number].sum + roll > PINS
  end

  def too_many_pins_error
    raise BowlingError, 'Frame cannot have that many pins'
  end

  public

  attr_reader :frames, :frame_number

  def tenth_frame?
    frame_number == 10
  end

  def build(pins)
    validate(pins)

    tenth_frame? and make_tenth_frame_builder and tenth_frame.validate(pins)

    frames[frame_number] << pins
    frame_full? && normal_frame? and increment_frame_number
  end
end

# Tenth frame specific stuff
class TenthFrame < Frame
  attr_accessor :rolls

  def initialize(rolls)
    self.rolls = rolls
  end

  def qualifies_for_bonus_roll?
    strike?(rolls) || spare?(rolls.first(2))
  end

  def full?
    rolls.size == 3 || (rolls.size == 2 && !qualifies_for_bonus_roll?)
  end

  def too_many_pins?(roll)
    return false if rolls.all?(Game::STRIKE) && rolls.size <= 3

    rolls.size == 2 &&
      strike?(rolls) && rolls[1] + roll > PINS
  end

  def validate(roll)
    too_many_pins?(roll) and too_many_pins_error
  end
end
