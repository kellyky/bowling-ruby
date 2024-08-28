require_relative 'frame'
require_relative 'frame_type'
require_relative 'bowling'

class Score
  include FrameType

  def self.game(frames)
    new(frames).score_game
  end

  def initialize(frames)
    self.frames = frames
  end

  attr_accessor :frames

  def score_game
    score = 0

    current_frame = frames.head

    until current_frame.nil?
      score += single_frame_score(current_frame)
      current_frame = current_frame.next_frame
    end

    score
  end

  def single_frame_score(current_frame)
    return current_frame.rolls.sum if current_frame.tenth_frame?

    throws = current_frame.rolls

    case
    when strike?(throws) then score_strike(current_frame)
    when spare?(throws) then score_spare(current_frame)
    when open?(throws) then throws.sum
    end
  end

  def score_spare(current_frame)
    next_roll = current_frame.next_frame.rolls.first
    Frame::PINS + next_roll
  end

  def score_strike(current_frame)
    Frame::PINS + next_two_rolls(current_frame)
  end

  def next_two_rolls(current_frame)
    next_frame = current_frame.next_frame
    case next_frame.rolls.size
    when 1
      next_frame.rolls.sum + next_frame.next_frame.rolls.first
    when 2..3
      next_frame.rolls.first(2).sum
    else
      raise Game::BowlingError, 'Frame must have 1-2 rolls (3 allowed for 10th frame)'
    end
  end
end
