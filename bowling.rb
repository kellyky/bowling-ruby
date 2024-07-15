require 'pry-byebug'
class Game
  attr_accessor :rolls
  attr_reader :score, :frames

  def initialize
    @score= 0
    @frame_builder = Frame.new
    @frames = {}
  end

  def roll(pins)
    raise Game::BowlingError if pins.negative?
    raise Game::BowlingError if ten_frames_played?

    # build frame, merge with game frames
    @frame_builder.build(pins)
    @frames.merge!(@frame_builder.frames)

  end

  def ten_frames_played?
    @frame_builder.frame_ten_full
  end

  def score
    raise Game::BowlingError unless ten_frames_played?

    @frames.each do |frame_num, throws|
      @frame_score_builder = Score.new(frame_num, throws, frames)

      if frame_num == 10
        @score+= throws.sum
      else
        @frame_score_builder.calculate
        @score+= @frame_score_builder.frame_score
      end

    end
    @score
  end

  class BowlingError < StandardError
  end
end

class Score < Game
  attr_reader :frame_score, :throws, :frame_number

  def initialize(frame_number, throws, frames)
    @frame_score = 0
    @frame_number = frame_number
    @throws = throws
    @frames = frames
  end

  def calculate
    score_strike if strike?
    score_spare if spare?
    score_open if open?
  end

  def score_strike
    next_frame = @frames[frame_number + 1]
    case next_frame.size
    when 3
      @frame_score += next_frame.first(2).sum
    when 2
      @frame_score += next_frame.sum
    when 1
      @frame_score += next_frame.sum
      @frame_score += @frames[frame_number + 2].first
    end

    @frame_score += 10
  end

  def strike?
    throws.sum == 10 && throws.size == 1
  end

  def score_spare
    @frame_score += 10

    @frame_score += @frames[frame_number + 1].first
  end

  def spare?
    throws.sum == 10 && throws.size == 2
  end

  def score_open
    @frame_score += throws.sum
  end

  def open?
    throws.sum < 10
  end

end

# Responsible for building of frames
class Frame < Game
  attr_reader :frames, :frame_ten_full

  def initialize
    @frame_ten_full = false
    @frame_number = 1
    @frames = { 1=>[], 2=>[], 3=>[], 4=>[], 5=>[], 6=>[], 7=>[], 8=>[], 9=>[], 10=>[] }
  end

  def bonus_roll?
    rolls = frames[@frame_number]

    if @frame_number == 10 && rolls.size == 2
      return true if rolls.first == 10 || rolls.last == 10 || rolls.sum == 10
    end

    false
  end

  def build(roll)
    raise Game::BowlingError if too_many_pins?(roll)

    add_roll_to_frame(roll)

    increment_frame_number if frame_full? && !tenth_frame?

  end

  def increment_frame_number
    @frame_number += 1
  end

  def add_roll_to_frame(roll)
    frames[@frame_number] << roll
  end

  def frame_full?
    rolls = frames[@frame_number]

    tenth_frame? ? frame_ten_full?(rolls) : earlier_frame_full?(rolls)
  end

  def tenth_frame?
    @frame_number == 10
  end

  # FIXME?
  def frame_ten_full?(rolls)
    return false if rolls.size == 1

    if rolls.size == 3 || (rolls.size == 2 && !bonus_roll?)
      @frame_ten_full = true

      return true
    end
  end

  def earlier_frame_full?(rolls)
    rolls.first == 10 || rolls.size == 2
  end

  def more_than_ten_pins?(roll)
    frames[@frame_number].sum + roll > 10
  end

  # def strike_followed_by_more_than_ten_pin_spare?(roll)
  # end


  def too_many_pins?(roll)
    return true if roll > 10
    return more_than_ten_pins?(roll) unless tenth_frame?

    tenth_frame = frames[@frame_number]

    return false if tenth_frame.all?(10)

    if tenth_frame.size == 2
      tenth_frame.first == 10 && tenth_frame[1] + roll > 10
    end

  end
end
