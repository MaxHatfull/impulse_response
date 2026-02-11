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
      ].map { |corner| RectUtils.direction_to_world_space(corner, rotation: rotation) }

      xs = corners.map { |c| c[0] }
      ys = corners.map { |c| c[1] }

      AABB.new(cx + xs.min, cy + ys.min, cx + xs.max, cy + ys.max)
    end

    def raycast(ray, tag: nil)
      return nil unless matches_tag?(tag)

      half_width = @width / 2.0
      half_height = @height / 2.0

      # Transform ray to local space (centered at origin, no rotation)
      local_start = RectUtils.to_local_space(ray.start_point, center: center, rotation: rotation)
      local_dir = RectUtils.direction_to_local_space(ray.direction, rotation: rotation)

      hit = RectUtils.slab_intersection(
        min_x: -half_width, min_y: -half_height,
        max_x: half_width, max_y: half_height,
        ray_start: local_start, ray_dir: local_dir, ray_length: ray.length
      )
      return nil unless hit

      t_enter = hit[:t_enter]
      t_exit = hit[:t_exit]
      entry_axis = hit[:entry_axis]
      exit_axis = hit[:exit_axis]

      # Check if ray starts inside
      starts_inside = t_enter < 0

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
        entry_normal = RectUtils.direction_to_world_space(local_entry_normal, rotation: rotation)
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
        exit_normal = RectUtils.direction_to_world_space(local_exit_normal, rotation: rotation)
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

      local_point = RectUtils.to_local_space(point, center: center, rotation: rotation)

      local_point[0] > -half_width &&
        local_point[0] < half_width &&
        local_point[1] > -half_height &&
        local_point[1] < half_height
    end
  end
end
