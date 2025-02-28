require_relative 'frame'
require_relative 'frame_collection'
require_relative 'score'

class Game
  include BowlingException

  VALID_ROLL = ->(pins) { (0..PINS).include?(pins) }

  INVALID_ROLL_MESSAGE = 'Number of pins must be a number that includes 0 through %d'

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
    not current_frame or current_frame.frame_full?
  end

  def create_frame
    frames.add_new_frame
    self.current_frame = frames.tail
  end

  public

  def roll(pins)
    raise BowlingError, INVALID_ROLL_MESSAGE % PINS unless VALID_ROLL.call(pins)

    raise BowlingError, 'Frame is full' if bowling_frames_full?

    create_frame if need_new_frame?

    current_frame.add_roll(pins)
    current_frame.frame_type if current_frame.frame_full?
  end

  def score
    raise BowlingError, 'Game must be completed before it can be scored' unless bowling_frames_full?

    Score.game(frames)
  end

end
