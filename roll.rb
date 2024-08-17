require_relative 'score'

# The roll in a frame - validating valid pins in a roll
class Roll
  include BowlingExeption

  BOWLING_PINS = 0..10

  def self.validate(pins)
    BOWLING_PINS.include?(pins) or raise BowlingError, 'Pins needs to be in valid range (0 - 10)'
  end
end
