require_relative 'frame'
require_relative 'bowling_exception'

class Roll
  include BowlingException

  BOWLING_PINS = 0..Frame::PINS

  attr_accessor :pins

  def initialize(pins)
    self.pins = pins
  end

  def valid_roll?
    BOWLING_PINS.include?(pins)
  end

  def validate
    raise BowlingError unless valid_roll?
  end
end
