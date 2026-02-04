module Physics
  module Collisions
    class CircleRect
      def self.check(circle, rect)
        half_w = rect.width / 2.0
        half_h = rect.height / 2.0

        closest_x = clamp(circle.center[0], rect.center[0] - half_w, rect.center[0] + half_w)
        closest_y = clamp(circle.center[1], rect.center[1] - half_h, rect.center[1] + half_h)
        closest_point = Vector[closest_x, closest_y]

        to_circle = circle.center - closest_point
        distance_sq = to_circle.dot(to_circle)

        if distance_sq == 0
          return check_center_inside(circle, rect, half_w, half_h)
        end

        return nil if distance_sq >= circle.radius * circle.radius

        distance = Math.sqrt(distance_sq)
        penetration = circle.radius - distance
        normal = -to_circle / distance
        contact_point = circle.center + normal * circle.radius

        Collision.new(
          collider_a: circle,
          collider_b: rect,
          penetration: penetration,
          normal: normal,
          contact_point: contact_point
        )
      end

      def self.clamp(value, min, max)
        [[value, min].max, max].min
      end

      def self.check_center_inside(circle, rect, half_w, half_h)
        dx_left = circle.center[0] - (rect.center[0] - half_w)
        dx_right = (rect.center[0] + half_w) - circle.center[0]
        dy_bottom = circle.center[1] - (rect.center[1] - half_h)
        dy_top = (rect.center[1] + half_h) - circle.center[1]

        min_dist = [dx_left, dx_right, dy_bottom, dy_top].min

        if min_dist == dx_left
          normal = Vector[-1, 0]
          penetration = dx_left + circle.radius
        elsif min_dist == dx_right
          normal = Vector[1, 0]
          penetration = dx_right + circle.radius
        elsif min_dist == dy_bottom
          normal = Vector[0, -1]
          penetration = dy_bottom + circle.radius
        else
          normal = Vector[0, 1]
          penetration = dy_top + circle.radius
        end

        contact_point = circle.center + normal * circle.radius

        Collision.new(
          collider_a: circle,
          collider_b: rect,
          penetration: penetration,
          normal: normal,
          contact_point: contact_point
        )
      end
    end
  end
end
