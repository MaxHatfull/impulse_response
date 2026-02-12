module Physics
  module RectUtils
    # Transform a point from world space to local space (centered at origin, no rotation)
    def self.to_local_space(point, center:, rotation:)
      dx = point[0] - center[0]
      dy = point[1] - center[1]

      return Vector[dx, dy] if rotation == 0

      cos_r = Math.cos(-rotation)
      sin_r = Math.sin(-rotation)
      Vector[dx * cos_r - dy * sin_r, dx * sin_r + dy * cos_r]
    end

    # Transform a direction from world space to local space
    def self.direction_to_local_space(dir, rotation:)
      return dir if rotation == 0

      cos_r = Math.cos(-rotation)
      sin_r = Math.sin(-rotation)
      Vector[dir[0] * cos_r - dir[1] * sin_r, dir[0] * sin_r + dir[1] * cos_r]
    end

    # Transform a direction from local space to world space
    def self.direction_to_world_space(dir, rotation:)
      return dir if rotation == 0

      cos_r = Math.cos(rotation)
      sin_r = Math.sin(rotation)
      Vector[dir[0] * cos_r - dir[1] * sin_r, dir[0] * sin_r + dir[1] * cos_r]
    end

    # Slab intersection algorithm for axis-aligned rectangles
    # Returns nil if no intersection, otherwise returns a hash with:
    #   t_enter: distance along ray to entry point (negative if ray starts inside)
    #   t_exit: distance along ray to exit point
    #   entry_axis: :x or :y - which axis boundary was hit on entry
    #   exit_axis: :x or :y - which axis boundary was hit on exit
    #
    # Set ray_length to Float::INFINITY for infinite rays
    def self.slab_intersection(min_x:, min_y:, max_x:, max_y:, ray_start:, ray_dir:, ray_length: Float::INFINITY)
      # Extract vector components to avoid repeated Vector#[] calls
      rs0, rs1 = ray_start[0], ray_start[1]
      rd0, rd1 = ray_dir[0], ray_dir[1]

      if rd0 != 0.0
        t_min_x = (min_x - rs0) / rd0
        t_max_x = (max_x - rs0) / rd0
        t_min_x, t_max_x = t_max_x, t_min_x if t_min_x > t_max_x
      else
        return nil if rs0 < min_x || rs0 > max_x
        t_min_x = -Float::INFINITY
        t_max_x = Float::INFINITY
      end

      if rd1 != 0.0
        t_min_y = (min_y - rs1) / rd1
        t_max_y = (max_y - rs1) / rd1
        t_min_y, t_max_y = t_max_y, t_min_y if t_min_y > t_max_y
      else
        return nil if rs1 < min_y || rs1 > max_y
        t_min_y = -Float::INFINITY
        t_max_y = Float::INFINITY
      end

      t_enter = t_min_x > t_min_y ? t_min_x : t_min_y
      t_exit = t_max_x < t_max_y ? t_max_x : t_max_y

      # No intersection if entry is after exit, or exit is behind ray start
      return nil if t_enter > t_exit
      return nil if t_exit < 0

      # No intersection if ray is too short to reach the rect (and doesn't start inside)
      return nil if t_enter > 0 && t_enter > ray_length

      {
        t_enter: t_enter,
        t_exit: t_exit,
        entry_axis: t_enter == t_min_x ? :x : :y,
        exit_axis: t_exit == t_max_x ? :x : :y
      }
    end
  end
end
