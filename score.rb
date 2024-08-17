require_relative 'bowling_exception'
require_relative 'frame_type'

# Responsible for scoring each frame
class Score
  MAX_PINS_PER_FRAME = 10
  ONE_MORE_FRAME = 1
  TWO_MORE_FRAMES = 2

  include BowlingExeption
  include FrameType

  attr_reader :throws, :frame_number, :frames

  private

  def initialize(frame_number, throws, frames)
    @frame_number = frame_number
    @throws = throws
    @frames = frames
  end

  def next_two_rolls
    next_frame = frames[frame_number.next]

    case next_frame.size
    when 1
      next_frame.sum + frames[frame_number + TWO_MORE_FRAMES].first
      next_frame.sum + frames[frame_number.next.next].first
    when 2..3
      next_frame.first(2).sum
    else
      raise BowlingError, 'Frame must have 1-2 rolls (3 allowed for 10th frame)'
    end
  end

  def score_strike
    MAX_PINS_PER_FRAME + next_two_rolls
  end

  def score_spare
    MAX_PINS_PER_FRAME + frames[frame_number + ONE_MORE_FRAME].first
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
    when strike?(throws) then score_strike
    when spare?(throws) then score_spare
    when open?(throws) then score_open
    end
  end
end
