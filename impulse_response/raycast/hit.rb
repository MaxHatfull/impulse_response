module Raycast
  class Hit
    attr_reader :target, :point, :distance, :normal

    def initialize(target:, point:, distance:, normal:)
      @target = target
      @point = point
      @distance = distance
      @normal = normal.normalize
    end
  end
end
