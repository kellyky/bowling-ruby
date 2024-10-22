module BowlingException

  class BowlingError < ArgumentError
    DEFAULT_MESSAGE = "Must adhere to bowling rules. More information: https://exercism.org/tracks/ruby/exercises/bowling"

    def initialize(message = DEFAULT_MESSAGE)
      super
    end

  end

end
