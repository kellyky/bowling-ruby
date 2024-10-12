require_relative 'frame'
require_relative 'frame_type'
require_relative 'bowling'

class Score
  include FrameType

  def self.game(frames)
    new(frames).score_game
  end

  private

  attr_accessor :frames
  attr_reader :score_by_frame_type

  def initialize(frames)
    self.frames = frames
    @score_by_frame_type = {
      strike?: ->(frame) { Frame::PINS + next_two_rolls(frame) },
      spare?: ->(frame) { Frame::PINS + frame.next_frame.rolls.first },
      open?: ->(frame) { frame.rolls.sum }
    }
  end

  def single_frame_score(frame)
    return frame.rolls.sum if frame.tenth_frame?

    score_by_frame_type.each do |frame_type, score_frame|
      return score_frame.call(frame) if frame_type_match?(frame_type, frame)
    end
  end

  def frame_type_match?(frame_type, frame)
    send(frame_type, frame.rolls)
  end

  def next_two_rolls(frame)
    next_frame = frame.next_frame
    case next_frame.rolls.size
    when 1
      next_frame.rolls.sum + next_frame.next_frame.rolls.first
    when 2..3
      next_frame.rolls.first(2).sum
    else
      raise Game::BowlingError, 'Too many rolls for frame'
    end
  end

  public

  def score_game
    score = 0

    frame = frames.head

    while frame
      score += single_frame_score(frame)
      frame = frame.next_frame
    end

    score
  end
end
