module Raycast
  class Ray
    attr_reader :start_point, :direction, :length

    def initialize(start_point:, direction:, length:)
      @start_point = start_point
      @direction = direction
      @length = length
    end
  end
end
