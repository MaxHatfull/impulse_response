module Physics
  class RectCollider < Collider
    serialize :width, :height
    attr_reader :width, :height

    def aabb
      half_width = @width / 2.0
      half_height = @height / 2.0
      cx, cy = center[0], center[1]
      AABB.new(cx - half_width, cy - half_height, cx + half_width, cy + half_height)
    end

    def raycast(ray)
      half_width = @width / 2.0
      half_height = @height / 2.0

      min_x = center[0] - half_width
      max_x = center[0] + half_width
      min_y = center[1] - half_height
      max_y = center[1] + half_height

      # t refers to units along the ray

      if ray.direction[0] != 0
        t_min_x = (min_x - ray.start_point[0]) / ray.direction[0]
        t_max_x = (max_x - ray.start_point[0]) / ray.direction[0]
        t_min_x, t_max_x = t_max_x, t_min_x if t_min_x > t_max_x
      else
        return nil if ray.start_point[0] < min_x || ray.start_point[0] > max_x
        t_min_x = -Float::INFINITY
        t_max_x = Float::INFINITY
      end

      if ray.direction[1] != 0
        t_min_y = (min_y - ray.start_point[1]) / ray.direction[1]
        t_max_y = (max_y - ray.start_point[1]) / ray.direction[1]
        t_min_y, t_max_y = t_max_y, t_min_y if t_min_y > t_max_y
      else
        return nil if ray.start_point[1] < min_y || ray.start_point[1] > max_y
        t_min_y = -Float::INFINITY
        t_max_y = Float::INFINITY
      end

      t_enter = [t_min_x, t_min_y].max
      t_exit = [t_max_x, t_max_y].min

      return nil if t_enter > t_exit
      return nil if t_enter < 0
      return nil if t_enter > ray.length

      point = ray.start_point + ray.direction * t_enter

      normal = if t_enter == t_min_x
        Vector[ray.direction[0] > 0 ? -1 : 1, 0]
      else
        Vector[0, ray.direction[1] > 0 ? -1 : 1]
      end

      RaycastHit.new(collider: self, point: point, distance: t_enter, normal: normal)
    end

    def inside?(point)
      half_width = @width / 2.0
      half_height = @height / 2.0

      point[0] > center[0] - half_width &&
        point[0] < center[0] + half_width &&
        point[1] > center[1] - half_height &&
        point[1] < center[1] + half_height
    end
  end
end
