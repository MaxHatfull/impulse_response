module Physics
  class RaycastHit
    attr_reader :collider, :point, :distance, :normal

    def initialize(collider:, point:, distance:, normal:)
      @collider = collider
      @point = point
      @distance = distance
      @normal = normal.normalize
    end
  end
end
