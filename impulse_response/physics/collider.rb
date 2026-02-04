module Physics
  class Collider < Engine::Component
    def awake
      Physics.register_collider(self)
    end

    def destroy
      Physics.deregister_collider(self)
    end
  end
end
