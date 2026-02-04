module Raycast
  class Collider < Engine::Component
    def awake
      Raycast.register_collider(self)
    end

    def destroy
      Raycast.deregister_collider(self)
    end
  end
end
