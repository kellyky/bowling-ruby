require_relative 'frame'

class FrameCollection
  attr_accessor :frame_number, :tail, :head

  def initialize
    self.frame_number = 0
  end

  def add_new_frame
    self.frame_number += 1

    if tail.nil?
      self.tail = Frame.new(frame_number)
    else
      tail.next_frame = Frame.new(frame_number)
      self.tail = tail.next_frame
    end

    tail.tenth_frame = true if tail.tenth_frame?

    self.head = tail if head.nil?
  end
end
