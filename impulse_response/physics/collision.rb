module Physics
  class Collision
    attr_reader :collider_a, :collider_b, :penetration, :normal, :contact_point

    def initialize(collider_a:, collider_b:, penetration:, normal:, contact_point:)
      @collider_a = collider_a
      @collider_b = collider_b
      @penetration = penetration
      @normal = normal.normalize
      @contact_point = contact_point
    end
  end
end
