require_relative 'frame'

# Responsible for game-play logic
class Game
  include BowlingExeption

  STRIKE = Frame::PINS
  MAX_ROLLS_PER_REGULAR_FRAME = 2

  private

  attr_accessor :frames, :frame_builder

  def initialize
    self.frame_builder = Frame.new
    self.frames = {}
  end

  def ten_frames_played?
    frame_number = frame_builder.frame_number
    rolls = frame_builder.frames[frame_number]

    frame_builder.tenth_frame? && TenthFrame.new(rolls).full?
  end

  public

  def roll(pins)
    raise BowlingError, 'All 10 frames already played' if ten_frames_played?
    frame_builder.build(pins)
    frames.merge!(frame_builder.frames)
  end

  def score
    raise BowlingError, 'Game is not complete' unless ten_frames_played?

    Score.game(frames)
  end
end
