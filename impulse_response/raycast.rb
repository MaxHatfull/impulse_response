module Raycast
  def self.targets
    @targets ||= []
  end

  def self.register_target(target)
    targets << target
  end

  def self.deregister_target(target)
    targets.delete(target)
  end

  def self.hits(ray)
    targets.filter_map { |target| target.hit(ray) }
  end

  def self.closest_hit(ray)
    hits(ray).min_by(&:distance)
  end

  def self.targets_at(point)
    targets.select { |target| target.inside?(point) }
  end

  def self.clear_targets
    @targets = []
  end
end
