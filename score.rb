require_relative 'frame'
require_relative 'frame_type'
require_relative 'bowling'

class Score
  include FrameType

  SCORE_FRAME = {
    strike: ->(frame) { Game::PINS + next_two_rolls(frame) },
     spare: ->(frame) { Game::PINS + frame.next_frame.rolls.first },
      open: ->(frame) { frame.rolls.sum },
  }

  class << self

    private

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

  end

  def self.game(frames)
    new(frames).score_game
  end

  private

  attr_accessor :frames

  def initialize(frames)
    self.frames = frames
  end

  def single_frame_score(fframe)
    require 'pry-byebug'
    binding.pry
    return fframe.rolls.sum if fframe.tenth_frame?

    SCORE_FRAME[fframe.score_as].call(fframe)
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
