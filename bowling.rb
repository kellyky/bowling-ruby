require_relative  'frame'
require_relative  'score'

# Responsible for game-play logic
class Game
  PINS_PER_FRAME = 10
  STRIKE = 10
  MAX_ROLLS_PER_REGULAR_FRAME = 2

  attr_reader :score, :frames

  private

  def initialize
    @score = 0
    @frame_builder = Frame.new
    @frames = {}
  end

  def validate_roll(pins)
    raise Game::BowlingError, 'All 10 frames already played' if ten_frames_played?
  end

  def ten_frames_played?
    frame_number = @frame_builder.frame_number
    rolls = @frame_builder.frames[frame_number]

    @frame_builder.tenth_frame? && TenthFrame.new(rolls).full?
  end

  public

  def roll(pins)
    validate_roll(pins)
    @frame_builder.build(pins)
    @frames.merge!(@frame_builder.frames)
  end

  def score
    raise Game::BowlingError, 'Game is not complete' unless ten_frames_played?

    @frames.each do |frame_num, throws|
      @frame_score_builder = Score.new(frame_num, throws, frames)

      @score += if frame_num == 10
                  @frame_score_builder.tenth_frame
                else
                  @frame_score_builder.calculate
                end
    end
    @score
  end

  private

  class BowlingError < StandardError
  end
end
