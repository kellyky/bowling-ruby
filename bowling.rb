require_relative 'frame'

# Responsible for game-play logic
class Game
  include BowlingExeption

  STRIKE = Frame::PINS
  MAX_ROLLS_PER_REGULAR_FRAME = 2

  private

  attr_reader :frames, :frame_builder

  def initialize
    @frame_builder = Frame.new
    @frames = {}
  end

  def validate_roll
    raise BowlingError, 'All 10 frames already played' if ten_frames_played?
  end

  def ten_frames_played?
    frame_number = frame_builder.frame_number
    rolls = frame_builder.frames[frame_number]

    frame_builder.tenth_frame? && TenthFrame.new(rolls).full?
  end

  public

  def roll(pins)
    validate_roll
    frame_builder.build(pins)
    frames.merge!(frame_builder.frames)
  end

  def score
    raise BowlingError, 'Game is not complete' unless ten_frames_played?

    Score.game(frames)
  end
end
