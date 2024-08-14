require_relative 'bowling'
require_relative 'frame'

# Scoring Rules - what is a strike, spare, open
module StrikeSpareOpen
  def strike?(throws)
    throws.first == Game::STRIKE
  end

  def spare?(throws)
    throws.sum == Game::PINS_PER_FRAME && throws.size == 2
  end

  def open?(throws)
    throws.sum < Game::PINS_PER_FRAME
  end
end
