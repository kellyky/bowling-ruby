require_relative 'frame'
require_relative 'frame_collection'
require_relative 'roll'
require_relative 'score'

class Game
  include BowlingException
  STRIKE = 10

  private

  def initialize
    self.frames = FrameCollection.new
    self.current_frame = nil
  end

  attr_accessor :frames, :current_frame

  def bowling_frames_full?
    frames.tail && frames.tail.tenth_frame && frames.tail.tenth_frame_full?
  end

  public

  def roll(pins)
    roll = Roll.new(pins)
    roll.validate

    raise BowlingError if bowling_frames_full?

    if current_frame.nil? || current_frame.frame_full?
      frames.add_new_frame
      self.current_frame = frames.tail
    end

    current_frame.add_roll(pins)
  end

  def score
    raise BowlingError unless bowling_frames_full?

    Score.game(frames)
  end
end
