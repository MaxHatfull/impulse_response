module Physics
  module Collisions
    class RectRect
      def self.check(a, b)
        a_half_w = a.width / 2.0
        a_half_h = a.height / 2.0
        b_half_w = b.width / 2.0
        b_half_h = b.height / 2.0

        dx = b.center[0] - a.center[0]
        dy = b.center[1] - a.center[1]

        overlap_x = a_half_w + b_half_w - dx.abs
        overlap_y = a_half_h + b_half_h - dy.abs

        return nil if overlap_x <= 0 || overlap_y <= 0

        if overlap_x < overlap_y
          normal = Vector[dx > 0 ? 1 : -1, 0]
          penetration = overlap_x
          contact_point = a.center + Vector[normal[0] * a_half_w, 0]
        else
          normal = Vector[0, dy > 0 ? 1 : -1]
          penetration = overlap_y
          contact_point = a.center + Vector[0, normal[1] * a_half_h]
        end

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
