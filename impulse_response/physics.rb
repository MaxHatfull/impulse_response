module Physics
  WORLD_BOUNDS = AABB.new(-500, -500, 500, 500)

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

  def self.raycast(ray)
    quadtree.query_ray(ray).filter_map { |collider| collider.raycast(ray) }
  end

  def self.closest_raycast(ray)
    raycast(ray).min_by(&:distance)
  end

  def self.colliders_at(point)
    quadtree.query_point(point).select { |collider| collider.inside?(point) }
  end

  def self.clear_colliders
    @quadtree = nil
  end

  def self.collisions(collider)
    quadtree.query(collider.aabb)
      .reject { |other| other == collider }
      .filter_map { |other| CollisionResolver.check(collider, other) }
  end
end
