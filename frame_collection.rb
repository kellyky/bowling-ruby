require_relative 'frame'

class FrameCollection

  private

  attr_accessor :frame_number, :tail, :head

  def initialize
    self.frame_number = 0
  end

  def advance_frame
    return unless tail

    tail.next_frame = Frame.new(frame_number)
    self.tail = tail.next_frame
  end

  def create_frame
    return if tail

    self.tail = Frame.new(frame_number)
  end



  public

  attr_reader :frame_number, :tail, :head

  def add_new_frame
    self.frame_number += 1

    advance_frame or create_frame

    tail.tenth_frame = true if tail.tenth_frame?

    self.head = tail unless head
  end

end
