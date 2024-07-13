require 'pry-byebug'
class Game
  attr_accessor :rolls
  attr_reader :score

  def initialize
    @score = 0
    @frame = 1
    @max_rolls = max_rolls
    @rolls = []
    @frames = { 1=>[], 2=>[], 3=>[], 4=>[], 5=>[], 6=>[], 7=>[], 8=>[], 9=>[], 10=>[] }
  end


  def roll(pins)
    raise Game::BowlingError.new('negative roll not allowed') if pins.negative?
    raise Game::BowlingError.new('there are only 10 pins') if pins > 10
    raise Game::BowlingError.new('10 frames already played') if ten_frames_played?

    @rolls << pins
  end

  def ten_frames_played?
    # FIXME - doesn't account for strikes earlier in the game
      # Revisit when I refactor roll method to build @frames with each roll
    return true if @rolls.size > 20
    return false if @rolls.size < 20

    tenth_frame_gets_fill_ball?
  end

  def tenth_frame_gets_fill_ball?
    !(@rolls.slice(-2, 2).include?(10) || @rolls.slice(-2, 2).sum == 10)
  end

  def max_rolls
    @frame == 10 ? 3 : 2
  end

  def game_has_ten_frames?
    !@frames[10].nil? && (@frames[10].size == 2 || @frames[10].size == 3)

  end

  def score
    construct_frames

    raise Game::BowlingError.new('Game must be played completly before scoring') unless @frames[10].size >= 2

    @frames.each do |frame_num, throws|
      if frame_num == 10
        @score += throws.compact.sum
      else
        score_frame(frame_num, throws)
      end

    end
    @score
  end

  private

  def score_frame(frame_num, throws)
    score_strike(frame_num) if strike?(throws)
    score_spare(frame_num) if spare?(throws)
    score_open(throws) if open?(throws)
  end

  def score_strike(num)
    next_frame = @frames[num + 1]
    case next_frame.size
    when 3
      @score += next_frame.first(2).sum
    when 2
      @score += next_frame.sum
    when 1
      @score += next_frame.sum
      @score += @frames[num + 2].first
    end

    @score += 10
  end

  def score_spare(frame_num)
    @score += 10

    @score += @frames[frame_num + 1].first
  end

  def score_open(throws)
    @score += throws.sum
  end


  def construct_frames
    reversed_rolls = @rolls.reverse

    (1..10).each do |frame|
      # @frames[frame] = []

      # Frame 10 can have 3 throws
      if frame == 10
        reversed_rolls.size.times { @frames[frame] << reversed_rolls.pop }
      else

        # Strike has 1 roll
        if reversed_rolls.last == 10
          @frames[frame] << reversed_rolls.pop
        else
          2.times {  @frames[frame] << reversed_rolls.pop }
        end
      end
    end
  end

  def spare?(throws)
    throws.sum == 10 && throws.size == 2
  end

  def strike?(throws)
    throws.sum == 10 && throws.size == 1
  end

  def open?(throws)
    throws.sum < 10
  end

  class BowlingError < StandardError
    def initialize(message)
      @message = message
    end
  end
end
