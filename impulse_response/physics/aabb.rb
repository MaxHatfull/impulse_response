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
      # Slab intersection algorithm
      dir_x = ray.direction[0]
      dir_y = ray.direction[1]
      start_x = ray.start_point[0]
      start_y = ray.start_point[1]

      if dir_x != 0
        t_min_x = (@min_x - start_x) / dir_x
        t_max_x = (@max_x - start_x) / dir_x
        t_min_x, t_max_x = t_max_x, t_min_x if t_min_x > t_max_x
      else
        return false if start_x < @min_x || start_x > @max_x
        t_min_x = -Float::INFINITY
        t_max_x = Float::INFINITY
      end

      if dir_y != 0
        t_min_y = (@min_y - start_y) / dir_y
        t_max_y = (@max_y - start_y) / dir_y
        t_min_y, t_max_y = t_max_y, t_min_y if t_min_y > t_max_y
      else
        return false if start_y < @min_y || start_y > @max_y
        t_min_y = -Float::INFINITY
        t_max_y = Float::INFINITY
      end

      t_enter = t_min_x > t_min_y ? t_min_x : t_min_y
      t_exit = t_max_x < t_max_y ? t_max_x : t_max_y

      return false if t_enter > t_exit
      return false if t_exit < 0
      return false if t_enter > ray.length

      true
    end

    def center_x
      (@min_x + @max_x) / 2.0
    end

    def center_y
      (@min_y + @max_y) / 2.0
    end
  end
end
