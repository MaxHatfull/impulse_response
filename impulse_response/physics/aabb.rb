module Physics
  class AABB
    attr_reader :min_x, :min_y, :max_x, :max_y

    def initialize(min_x, min_y, max_x, max_y)
      @min_x = min_x
      @min_y = min_y
      @max_x = max_x
      @max_y = max_y
    end

    def contains_point?(point)
      point[0] >= @min_x && point[0] <= @max_x &&
        point[1] >= @min_y && point[1] <= @max_y
    end

    def contains_aabb?(other)
      other.min_x >= @min_x && other.max_x <= @max_x &&
        other.min_y >= @min_y && other.max_y <= @max_y
    end

    def intersects?(other)
      @min_x <= other.max_x && @max_x >= other.min_x &&
        @min_y <= other.max_y && @max_y >= other.min_y
    end

    def intersects_ray?(ray)
      RectUtils.slab_intersection(
        min_x: @min_x, min_y: @min_y, max_x: @max_x, max_y: @max_y,
        ray_start: ray.start_point, ray_dir: ray.direction, ray_length: ray.length
      ) != nil
    end

    def center_x
      (@min_x + @max_x) / 2.0
    end

    def center_y
      (@min_y + @max_y) / 2.0
    end
  end
end
