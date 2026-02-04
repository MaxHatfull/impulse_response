module Raycast
  class Target
    include Engine::Serializable

    def awake
      Raycast.register_target(self)
    end

    def destroy
      Raycast.deregister_target(self)
    end
  end
end
