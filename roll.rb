require_relative 'frame'
require_relative 'bowling'
require_relative 'bowling_exception'

class Roll
  include BowlingException

  private

  attr_accessor :pins

  def initialize(pins)
    self.pins = pins
  end

  def valid_roll?
    (0..Game::PINS).include?(pins)
  end

  public

  def validate
    raise BowlingError, 'Number of pins must be a number that includes 0 through %d' % [Game::PINS] unless valid_roll?
  end

end
