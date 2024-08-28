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

  public

  def roll(pins)
    roll = Roll.new(pins)
    roll.validate

    raise BowlingError if no_more_rolls_available?

    if current_frame.nil? || current_frame.frame_full?
      frames.add_new_frame
      self.current_frame = frames.tail
    end

    current_frame.add_roll(pins)
  end

  def no_more_rolls_available?
    !frames.tail.nil? && frames.tail.tenth_frame && frames.tail.tenth_frame_full?
  end

  def score
    raise BowlingError unless no_more_rolls_available?

    Score.game(frames)
  end
end
