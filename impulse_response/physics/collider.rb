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
      Vector[game_object.pos[0], game_object.pos[2]]
    end

    def aabb
      raise NotImplementedError, "Subclasses must implement #aabb"
    end

    def matches_tag?(tag)
      tag.nil? || tags.include?(tag)
    end
  end
end
