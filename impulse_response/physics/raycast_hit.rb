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
      (@entry_point - @ray.start_point).magnitude
    end
  end
end
