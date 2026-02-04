module Physics
  def self.colliders
    @colliders ||= []
  end

  def self.register_collider(collider)
    colliders << collider
  end

  def self.deregister_collider(collider)
    colliders.delete(collider)
  end

  def self.raycast(ray)
    colliders.filter_map { |collider| collider.raycast(ray) }
  end

  def self.closest_raycast(ray)
    raycast(ray).min_by(&:distance)
  end

  def self.colliders_at(point)
    colliders.select { |collider| collider.inside?(point) }
  end

  def self.clear_colliders
    @colliders = []
  end

  def self.collisions(collider)
    colliders
      .reject { |other| other == collider }
      .filter_map { |other| CollisionResolver.check(collider, other) }
  end
end
