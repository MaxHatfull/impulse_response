module Physics
  module RectUtils
    # Slab intersection algorithm for axis-aligned rectangles
    # Returns nil if no intersection, otherwise returns a hash with:
    #   t_enter: distance along ray to entry point (negative if ray starts inside)
    #   t_exit: distance along ray to exit point
    #   entry_axis: :x or :y - which axis boundary was hit on entry
    #   exit_axis: :x or :y - which axis boundary was hit on exit
    #
    # Set ray_length to Float::INFINITY for infinite rays
    def self.slab_intersection(min_x:, min_y:, max_x:, max_y:, ray_start:, ray_dir:, ray_length: Float::INFINITY)
      if ray_dir[0] != 0.0
        t_min_x = (min_x - ray_start[0]) / ray_dir[0]
        t_max_x = (max_x - ray_start[0]) / ray_dir[0]
        t_min_x, t_max_x = t_max_x, t_min_x if t_min_x > t_max_x
      else
        return nil if ray_start[0] < min_x || ray_start[0] > max_x
        t_min_x = -Float::INFINITY
        t_max_x = Float::INFINITY
      end

      if ray_dir[1] != 0.0
        t_min_y = (min_y - ray_start[1]) / ray_dir[1]
        t_max_y = (max_y - ray_start[1]) / ray_dir[1]
        t_min_y, t_max_y = t_max_y, t_min_y if t_min_y > t_max_y
      else
        return nil if ray_start[1] < min_y || ray_start[1] > max_y
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
