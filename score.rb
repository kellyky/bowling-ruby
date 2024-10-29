require_relative 'frame'
require_relative 'bowling'

class Score

  SCORE_FRAME = {
    strike: ->(frame) { Game::PINS + next_two_rolls(frame) },
     spare: ->(frame) { Game::PINS + frame.next_frame.rolls.first },
      open: ->(frame) { frame.rolls.sum },
  }

  class << self

    private

    def next_two_rolls(frame)
      next_frame = frame.next_frame

      roll_quantity = next_frame.rolls.size

      strike_next_frame(next_frame, roll_quantity) or
        non_strike_next_frame(next_frame, roll_quantity) or
        raise Game::BowlingError, 'Too many rolls for frame'
    end

    def strike_next_frame(frame, roll_quantity)
      return unless roll_quantity in 1..1

      frame.rolls.sum + frame.next_frame.rolls.first
    end

    def non_strike_next_frame(frame, roll_quantity)
      return unless roll_quantity in 2..3

      frame.rolls.first(2).sum
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

  def single_frame_score(frame)
    return frame.rolls.sum if frame.tenth_frame?

    SCORE_FRAME[frame.score_as].call(frame)
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
