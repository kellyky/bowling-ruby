require_relative 'frame'
require_relative 'frame_collection'
require_relative 'roll'
require_relative 'score'

class Game
  include BowlingException

  PINS = 10
  STRIKE = PINS

  private

  def initialize
    self.frames = FrameCollection.new
  end

  attr_accessor :frames, :current_frame

  def bowling_frames_full?
    frames.tail&.tenth_frame && frames.tail&.tenth_frame_full?
  end

  def need_new_frame?
    !current_frame || current_frame.frame_full?
  end

  public

  def roll(pins)
    roll = Roll.new(pins)
    roll.validate

    raise BowlingError, 'Frame is full' if bowling_frames_full?

    if need_new_frame?
      frames.add_new_frame
      self.current_frame = frames.tail
    end

    current_frame.add_roll(pins)
  end

  def score
    raise BowlingError, 'Game must be completed before it can be scored' unless bowling_frames_full?

    Score.game(frames)
  end

end
