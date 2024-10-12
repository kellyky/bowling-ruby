require_relative 'frame'
require_relative 'bowling_exception'

class Roll
  include BowlingException

  BOWLING_PINS = 0..Frame::PINS

  private

  attr_accessor :pins

  def initialize(pins)
    self.pins = pins
  end

  def valid_roll?
    BOWLING_PINS.include?(pins)
  end

  public

  def validate
    raise BowlingError, "Invalid number of pins (#{pins}). Valid range is 0 through 10." unless valid_roll?
  end
end
