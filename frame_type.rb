require_relative 'bowling'

# Determine if a roll is a strike spare or open
module FrameType

  private

  def strike?(throws)
    throws.count == 1 && throws.sum == Game::STRIKE
  end

  def spare?(throws)
    throws.sum == Game::PINS && throws.size == 2
  end

  def open?(throws)
    throws.sum < Game::PINS
  end

end
