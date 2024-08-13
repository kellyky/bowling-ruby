require_relative 'bowling'
require_relative 'frame'

# Responsible for scoring each frame
class Score
  attr_reader :throws, :frame_number, :frames

  # Scoring checked from other classes
  def self.strike?(throw)
    throw == Game::STRIKE
  end

  # Scoring checked from other classes
  def self.spare?(throws)
    throws.sum == Game::PINS_PER_FRAME && throws.size == 2
  end

  private

  def initialize(frame_number, throws, frames)
    @frame_number = frame_number
    @throws = throws
    @frames = frames
  end

  def strike?
    throws.first == Game::STRIKE
  end

  # now also exists as class method
  def spare?
    throws.sum == Game::PINS_PER_FRAME && throws.size == 2
  end

  # now also exists as class method
  def open?
    throws.sum < Game::PINS_PER_FRAME
  end

  def next_two_rolls
    next_frame = frames[frame_number + 1]

    case next_frame.size
    when 1
      next_frame.sum + frames[frame_number + 2].first
    when 2..3
      next_frame.first(2).sum
    else
      raise Game::BowlingError, 'Frame must have 1-2 rolls (3 allowed for 10th frame)'
    end
  end

  def score_strike
    10 + next_two_rolls
  end

  def score_spare
    10 + frames[frame_number + 1].first
  end

  def score_open
    throws.sum
  end

  public

  def tenth_frame
    score_open
  end

  def calculate
    case
    when strike? then score_strike
    when spare? then score_spare
    when open? then score_open
    end
  end
end
