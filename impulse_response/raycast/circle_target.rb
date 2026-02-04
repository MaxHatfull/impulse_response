module Raycast
  class CircleTarget < Target
    serialize :center, :radius

    def hit(ray)
      # Vector from ray start to circle center
      to_center = @center - ray.start_point

      # Project onto ray direction to find closest approach
      proj_length = to_center.dot(ray.direction)

      return nil if proj_length < 0

      # |to_center|² = proj_length² + closest_dist²
      closest_dist_sq = to_center.dot(to_center) - proj_length * proj_length

      radius_sq = @radius * @radius
      return nil if closest_dist_sq > radius_sq

      # radius² = closest_dist² + half_chord²
      half_chord = Math.sqrt(radius_sq - closest_dist_sq)

      distance = proj_length - half_chord

      return nil if distance < 0
      return nil if distance > ray.length

      point = ray.start_point + ray.direction * distance
      normal = (point - @center).normalize

      Hit.new(target: self, point: point, distance: distance, normal: normal)
    end
  end
end
