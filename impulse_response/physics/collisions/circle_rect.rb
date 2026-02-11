module Physics
  module Collisions
    class CircleRect
      def self.check(circle, rect)
        half_w = rect.width / 2.0
        half_h = rect.height / 2.0

        # Transform circle center to rect's local space
        local_circle_center = RectUtils.to_local_space(circle.center, center: rect.center, rotation: rect.rotation)

        closest_x = clamp(local_circle_center[0], -half_w, half_w)
        closest_y = clamp(local_circle_center[1], -half_h, half_h)
        local_closest_point = Vector[closest_x, closest_y]

        to_circle = local_circle_center - local_closest_point
        distance_sq = to_circle.dot(to_circle)

        if distance_sq == 0
          return check_center_inside(circle, rect, half_w, half_h, local_circle_center)
        end

        return nil if distance_sq >= circle.radius * circle.radius

        distance = Math.sqrt(distance_sq)
        penetration = circle.radius - distance
        local_normal = -to_circle / distance
        # Transform normal back to world space
        normal = RectUtils.direction_to_world_space(local_normal, rotation: rect.rotation)
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

      def self.check_center_inside(circle, rect, half_w, half_h, local_center)
        dx_left = local_center[0] - (-half_w)
        dx_right = half_w - local_center[0]
        dy_bottom = local_center[1] - (-half_h)
        dy_top = half_h - local_center[1]

        min_dist = [dx_left, dx_right, dy_bottom, dy_top].min

        if min_dist == dx_left
          local_normal = Vector[-1, 0]
          penetration = dx_left + circle.radius
        elsif min_dist == dx_right
          local_normal = Vector[1, 0]
          penetration = dx_right + circle.radius
        elsif min_dist == dy_bottom
          local_normal = Vector[0, -1]
          penetration = dy_bottom + circle.radius
        else
          local_normal = Vector[0, 1]
          penetration = dy_top + circle.radius
        end

        normal = RectUtils.direction_to_world_space(local_normal, rotation: rect.rotation)
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
