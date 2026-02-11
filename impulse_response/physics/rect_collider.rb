module Physics
  class RectCollider < Collider
    serialize :width, :height
    attr_reader :width, :height

    def rotation
      # Get Y rotation from game object's euler angles (in radians)
      euler = game_object.euler_angles
      y_rotation = euler[1]

      # Handle gimbal lock: when X and Z are ±180°, adjust Y rotation
      if euler[0].abs > 90 || euler[2].abs > 90
        y_rotation = 180 - y_rotation
      end

      y_rotation * Math::PI / 180
    end

    def compute_aabb
      half_width = @width / 2.0
      half_height = @height / 2.0
      cx, cy = center[0], center[1]

      # Transform local corners to world space
      corners = [
        Vector[-half_width, -half_height],
        Vector[half_width, -half_height],
        Vector[half_width, half_height],
        Vector[-half_width, half_height]
      ].map { |corner| direction_to_world_space(corner) }

      xs = corners.map { |c| c[0] }
      ys = corners.map { |c| c[1] }

      AABB.new(cx + xs.min, cy + ys.min, cx + xs.max, cy + ys.max)
    end

    def raycast(ray, tag: nil)
      return nil unless matches_tag?(tag)

      half_width = @width / 2.0
      half_height = @height / 2.0

      # Transform ray to local space (centered at origin, no rotation)
      local_start = to_local_space(ray.start_point)
      local_dir = direction_to_local_space(ray.direction)

      min_x = -half_width
      max_x = half_width
      min_y = -half_height
      max_y = half_height

      # t refers to units along the ray
      if local_dir[0] != 0.0
        t_min_x = (min_x - local_start[0]) / local_dir[0]
        t_max_x = (max_x - local_start[0]) / local_dir[0]
        t_min_x, t_max_x = t_max_x, t_min_x if t_min_x > t_max_x
      else
        return nil if local_start[0] < min_x || local_start[0] > max_x
        t_min_x = -Float::INFINITY
        t_max_x = Float::INFINITY
      end

      if local_dir[1] != 0.0
        t_min_y = (min_y - local_start[1]) / local_dir[1]
        t_max_y = (max_y - local_start[1]) / local_dir[1]
        t_min_y, t_max_y = t_max_y, t_min_y if t_min_y > t_max_y
      else
        return nil if local_start[1] < min_y || local_start[1] > max_y
        t_min_y = -Float::INFINITY
        t_max_y = Float::INFINITY
      end

      t_enter = [t_min_x, t_min_y].max
      t_exit = [t_max_x, t_max_y].min

      # Track which axis determined entry/exit for normal calculation
      entry_axis = t_enter == t_min_x ? :x : :y
      exit_axis = t_exit == t_max_x ? :x : :y

      return nil if t_enter > t_exit
      return nil if t_exit < 0

      # Check if ray starts inside
      starts_inside = t_enter < 0

      # Ray is too short to reach entry point
      return nil if !starts_inside && t_enter > ray.length

      if starts_inside
        entry_point = ray.start_point
        entry_normal = nil
      else
        entry_point = ray.start_point + ray.direction * t_enter
        local_entry_normal = if entry_axis == :x
          Vector[local_dir[0] > 0 ? -1 : 1, 0]
        else
          Vector[0, local_dir[1] > 0 ? -1 : 1]
        end
        entry_normal = direction_to_world_space(local_entry_normal)
      end

      # Check if ray ends inside
      ends_inside = t_exit > ray.length

      if ends_inside
        exit_point = ray.start_point + ray.direction * ray.length
        exit_normal = nil
      else
        exit_point = ray.start_point + ray.direction * t_exit
        local_exit_normal = if exit_axis == :x
          Vector[local_dir[0] > 0 ? 1 : -1, 0]
        else
          Vector[0, local_dir[1] > 0 ? 1 : -1]
        end
        exit_normal = direction_to_world_space(local_exit_normal)
      end

      RaycastHit.new(
        ray: ray,
        entry_point: entry_point,
        exit_point: exit_point,
        entry_normal: entry_normal,
        exit_normal: exit_normal,
        collider: self
      )
    end

    def inside?(point, tag: nil)
      return false unless matches_tag?(tag)

      half_width = @width / 2.0
      half_height = @height / 2.0

      local_point = to_local_space(point)

      local_point[0] > -half_width &&
        local_point[0] < half_width &&
        local_point[1] > -half_height &&
        local_point[1] < half_height
    end

    private

    def to_local_space(point)
      return point - center if rotation == 0

      dx = point[0] - center[0]
      dy = point[1] - center[1]
      cos_r = Math.cos(-rotation)
      sin_r = Math.sin(-rotation)

      Vector[dx * cos_r - dy * sin_r, dx * sin_r + dy * cos_r]
    end

    def direction_to_local_space(dir)
      return dir if rotation == 0

      cos_r = Math.cos(-rotation)
      sin_r = Math.sin(-rotation)

      Vector[dir[0] * cos_r - dir[1] * sin_r, dir[0] * sin_r + dir[1] * cos_r]
    end

    def direction_to_world_space(dir)
      return dir if rotation == 0

      cos_r = Math.cos(rotation)
      sin_r = Math.sin(rotation)

      Vector[dir[0] * cos_r - dir[1] * sin_r, dir[0] * sin_r + dir[1] * cos_r]
    end
  end
end
