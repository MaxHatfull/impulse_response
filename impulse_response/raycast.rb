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
end
