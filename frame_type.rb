require_relative 'bowling'
require_relative 'frame'

# Determine if a roll is a strike spare or open
module FrameType
  def strike?(throws)
    throws.first == Game::STRIKE
  end

  def spare?(throws)
    throws.sum == Frame::PINS && throws.size == 2
  end

  def open?(throws)
    throws.sum < Frame::PINS
  end
end
