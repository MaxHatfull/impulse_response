module Physics
  WORLD_BOUNDS = AABB.new(0, -50, 50, 0)

  def self.quadtree
    @quadtree ||= Quadtree.new(WORLD_BOUNDS)
  end

  def self.register_collider(collider)
    quadtree.insert(collider)
  end

  def self.deregister_collider(collider)
    quadtree.remove(collider)
  end

  def self.update_collider(collider)
    quadtree.update(collider)
  end

  def self.raycast(ray, tag: nil)
    quadtree.query_ray(ray).filter_map { |collider| collider.raycast(ray, tag: tag) }
  end

  def self.closest_raycast(ray, tag: nil)
    raycast(ray, tag: tag).min_by(&:entry_distance)
  end

  def self.colliders_at(point, tag: nil)
    quadtree.query_point(point).select { |collider| collider.inside?(point, tag: tag) }
  end

  def self.clear_colliders
    @quadtree = nil
  end

  def self.collisions(collider, tag: nil)
    quadtree.query(collider.aabb)
      .reject { |other| other == collider }
      .filter_map { |other| CollisionResolver.check(collider, other, tag: tag) }
  end
end
