module Physics
  class CircleCollider < Collider
    serialize :radius
    attr_reader :radius

    def update(delta_time)
      super
      #Engine::Debug.sphere(game_object.pos, @radius, color: [1, 0, 1])
    end

    def compute_aabb
      cx, cy = center[0], center[1]
      AABB.new(cx - @radius, cy - @radius, cx + @radius, cy + @radius)
    end

    def raycast(ray, tag: nil)
      return nil unless matches_tag?(tag)

      # Vector from ray start to circle center
      to_center = center - ray.start_point

      # Project onto ray direction to find closest approach
      proj_length = to_center.dot(ray.direction)

      # |to_center|² = proj_length² + closest_dist²
      closest_dist_sq = to_center.dot(to_center) - proj_length * proj_length

      radius_sq = @radius * @radius
      return nil if closest_dist_sq > radius_sq

      # radius² = closest_dist² + half_chord²
      half_chord = Math.sqrt(radius_sq - closest_dist_sq)

      entry_distance = proj_length - half_chord
      exit_distance = proj_length + half_chord

      # Check if ray starts inside the circle
      starts_inside = entry_distance < 0

      # Ray completely misses (circle behind ray or ray too short to reach entry)
      return nil if !starts_inside && (proj_length < 0 || entry_distance > ray.length)

      # Ray ends before reaching the circle
      return nil if exit_distance < 0

      if starts_inside
        entry_point = ray.start_point
        entry_normal = nil
      else
        entry_point = ray.start_point + ray.direction * entry_distance
        entry_normal = (entry_point - center).normalize
      end

      # Check if ray ends inside the circle
      ends_inside = exit_distance > ray.length

      if ends_inside
        exit_point = ray.start_point + ray.direction * ray.length
        exit_normal = nil
      else
        exit_point = ray.start_point + ray.direction * exit_distance
        exit_normal = (exit_point - center).normalize
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

      diff = point - center
      distance_sq = diff.dot(diff)
      distance_sq < @radius * @radius
    end
  end
end
