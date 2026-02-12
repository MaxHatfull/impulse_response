module Physics
  class Quadtree
    attr_reader :bounds

    def initialize(bounds, max_objects: 4, max_depth: 8, depth: 0)
      @bounds = bounds
      @max_objects = max_objects
      @max_depth = max_depth
      @depth = depth
      @objects = []
      @children = nil
    end

    def insert(collider)
      if @children
        child = child_for(collider)
        if child
          child.insert(collider)
          return
        end
      end

      @objects << collider

      if @objects.size > @max_objects && @depth < @max_depth && @children.nil?
        split!
        redistribute_objects
      end
    end

    def remove(collider)
      if @children
        child = child_for(collider)
        if child
          return if child.remove(collider)
        end
      end

      @objects.delete(collider)
    end

    def update(collider)
      remove(collider)
      insert(collider)
    end

    def query(aabb)
      result = []

      return result unless @depth == 0 || @bounds.intersects?(aabb)

      @objects.each do |obj|
        result << obj if obj.aabb.intersects?(aabb)
      end

      if @children
        @children.each do |child|
          result.concat(child.query(aabb))
        end
      end

      result
    end

    def query_ray(ray)
      result = []

      return result unless @depth == 0 || @bounds.intersects_ray?(ray)

      @objects.each do |obj|
        result << obj if obj.aabb.intersects_ray?(ray)
      end

      if @children
        @children.each do |child|
          result.concat(child.query_ray(ray))
        end
      end

      result
    end

    def query_point(point)
      result = []

      return result unless @depth == 0 || @bounds.contains_point?(point)

      @objects.each do |obj|
        result << obj if obj.aabb.contains_point?(point)
      end

      if @children
        @children.each do |child|
          result.concat(child.query_point(point))
        end
      end

      result
    end

    def clear
      @objects.clear
      @children = nil
    end

    private

    def split!
      cx = @bounds.center_x
      cy = @bounds.center_y

      @children = [
        # NW
        Quadtree.new(
          AABB.new(@bounds.min_x, cy, cx, @bounds.max_y),
          max_objects: @max_objects, max_depth: @max_depth, depth: @depth + 1
        ),
        # NE
        Quadtree.new(
          AABB.new(cx, cy, @bounds.max_x, @bounds.max_y),
          max_objects: @max_objects, max_depth: @max_depth, depth: @depth + 1
        ),
        # SW
        Quadtree.new(
          AABB.new(@bounds.min_x, @bounds.min_y, cx, cy),
          max_objects: @max_objects, max_depth: @max_depth, depth: @depth + 1
        ),
        # SE
        Quadtree.new(
          AABB.new(cx, @bounds.min_y, @bounds.max_x, cy),
          max_objects: @max_objects, max_depth: @max_depth, depth: @depth + 1
        )
      ]
    end

    def redistribute_objects
      remaining = []
      @objects.each do |obj|
        child = child_for(obj)
        if child
          child.insert(obj)
        else
          remaining << obj
        end
      end
      @objects = remaining
    end

    def child_for(collider)
      return nil unless @children

      aabb = collider.aabb
      @children.find { |child| child.bounds.contains_aabb?(aabb) }
    end
  end
end
