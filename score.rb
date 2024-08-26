require_relative 'bowling_exception'
require_relative 'frame'
require_relative 'frame_type'

# Responsible for scoring each frame
class Score
  include BowlingExeption
  include FrameType

  ONE_MORE_FRAME = 1
  TWO_MORE_FRAMES = 2

  def self.game(frames)
    game_score = 0

    frames.each do |frame_number, throws|
      score = new(frame_number, throws, frames)

      game_score += if frame_number == 10
                      score.tenth_frame
                    else
                      score.frame
                    end
    end
    game_score
  end

  private

  attr_accessor :throws, :frame_number, :frames

  def initialize(frame_number, throws, frames)
    self.frame_number = frame_number
    self.throws = throws
    self.frames = frames
  end

  def next_two_rolls
    next_frame = frames[frame_number + ONE_MORE_FRAME]

    case next_frame.size
    when 1
      next_frame.sum + frames[frame_number + TWO_MORE_FRAMES].first
    when 2..3
      next_frame.first(2).sum
    else
      raise BowlingError, 'Frame must have 1-2 rolls (3 allowed for 10th frame)'
    end
  end

  def score_strike
    Frame::PINS + next_two_rolls
  end

  def score_spare
    Frame::PINS + frames[frame_number.next].first
  end

  def score_open
    throws.sum
  end

  public

  def tenth_frame
    score_open
  end

  def frame
    case
    when strike?(throws) then score_strike
    when spare?(throws) then score_spare
    when open?(throws) then score_open
    end
  end
end
