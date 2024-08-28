require_relative 'frame'

class FrameCollection
  private

  attr_accessor :frame_number, :tail, :head

  def initialize
    self.frame_number = 0
  end

  public

  attr_reader :frame_number, :tail, :head

  def add_new_frame
    self.frame_number += 1

    if tail
      tail.next_frame = Frame.new(frame_number)
      self.tail = tail.next_frame
    else
      self.tail = Frame.new(frame_number)
    end

    tail.tenth_frame = true if tail.tenth_frame?

    self.head = tail unless head
  end
end
