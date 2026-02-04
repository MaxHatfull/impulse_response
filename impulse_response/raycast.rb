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

  def self.test(ray)
    targets.filter_map { |target| target.test(ray) }
  end

  def self.clear_targets
    @targets = []
  end
end
