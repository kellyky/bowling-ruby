require_relative  'frame'

# Responsible for game-play logic
class Game
  PINS_PER_FRAME = 10
  STRIKE = 10
  MAX_ROLLS_PER_REGULAR_FRAME = 2

  private

  def initialize
    @score = 0
    @frame_builder = Frame.new
    @frames = {}
  end

  def validate_roll
    raise Game::BowlingError, 'All 10 frames already played' if ten_frames_played?
  end

  def ten_frames_played?
    frame_number = @frame_builder.frame_number
    rolls = @frame_builder.frames[frame_number]

    @frame_builder.tenth_frame? && TenthFrame.new(rolls).full?
  end

  public

  attr_reader :score, :frames

  def roll(pins)
    validate_roll
    @frame_builder.build(pins)
    frames.merge!(@frame_builder.frames)
  end

  def score
    raise Game::BowlingError, 'Game is not complete' unless ten_frames_played?

    @frames.each do |frame_number, throws|
      @frame_score_builder = Score.new(frame_number, throws, frames)

      @score += if frame_number == 10
                  @frame_score_builder.tenth_frame
                else
                  @frame_score_builder.calculate
                end
    end
    @score
  end

  class BowlingError < ArgumentError
  end
end
