module Physics
  module Collisions
    class CircleCircle
      def self.check(a, b)
        to_b = b.center - a.center
        distance_sq = to_b.dot(to_b)
        sum_radii = a.radius + b.radius

        return nil if distance_sq >= sum_radii * sum_radii

        distance = Math.sqrt(distance_sq)
        penetration = sum_radii - distance

        normal = distance > 0 ? to_b / distance : Vector[1, 0]
        contact_point = a.center + normal * a.radius

        Collision.new(
          collider_a: a,
          collider_b: b,
          penetration: penetration,
          normal: normal,
          contact_point: contact_point
        )
      end
    end
  end
end
