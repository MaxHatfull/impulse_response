module Raycast
  def self.colliders
    @colliders ||= []
  end

  def self.register_collider(collider)
    colliders << collider
  end

  def self.deregister_collider(collider)
    colliders.delete(collider)
  end

  def self.hits(ray)
    colliders.filter_map { |collider| collider.hit(ray) }
  end

  def self.closest_hit(ray)
    hits(ray).min_by(&:distance)
  end

  def self.colliders_at(point)
    colliders.select { |collider| collider.inside?(point) }
  end

  def self.clear_colliders
    @colliders = []
  end
end
