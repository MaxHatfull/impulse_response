module Physics
  class Collider < Engine::Component
    serialize :tags
    attr_reader :tags

    def start
      @tags ||= []
      Physics.register_collider(self)
      @last_center = center.dup
    end

    def update(delta_time)
      current = center
      if current != @last_center
        Physics.update_collider(self)
        @last_center = current.dup
      end
    end

    def destroy
      Physics.deregister_collider(self)
    end

    def center
      version = game_object.local_version
      return @cached_center if @cached_center_version == version

      @cached_center_version = version
      @cached_center = Vector[game_object.pos[0], game_object.pos[2]]
    end

    def aabb
      version = game_object.local_version
      return @cached_aabb if @cached_aabb_version == version

      @cached_aabb_version = version
      @cached_aabb = compute_aabb
    end

    def compute_aabb
      raise NotImplementedError, "Subclasses must implement #compute_aabb"
    end

    def matches_tag?(tag)
      tag.nil? || tags.include?(tag)
    end
  end
end
