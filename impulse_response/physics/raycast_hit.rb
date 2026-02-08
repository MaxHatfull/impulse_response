module Physics
  class RaycastHit
    attr_reader :ray, :entry_point, :exit_point, :collider

    def initialize(ray:, entry_point:, exit_point:, entry_normal:, exit_normal:, collider:)
      @ray = ray
      @entry_point = entry_point
      @exit_point = exit_point
      @entry_normal = entry_normal
      @exit_normal = exit_normal
      @collider = collider
    end

    def entry_normal
      @entry_normal&.normalize
    end

    def exit_normal
      @exit_normal&.normalize
    end

    def entry_distance
      @entry_distance ||= begin
        start_x, start_y = @ray.start_point[0], @ray.start_point[1]
        dx = @entry_point[0] - start_x
        dy = @entry_point[1] - start_y
        Math.sqrt(dx * dx + dy * dy)
      end
    end

    def exit_distance
      @exit_distance ||= begin
        start_x, start_y = @ray.start_point[0], @ray.start_point[1]
        dx = @exit_point[0] - start_x
        dy = @exit_point[1] - start_y
        Math.sqrt(dx * dx + dy * dy)
      end
    end
  end
end
