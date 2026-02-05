module Physics
  class Collider < Engine::Component
    def awake
      Physics.register_collider(self)
    end

    def destroy
      Physics.deregister_collider(self)
    end

    def center
      Vector[game_object.pos[0], game_object.pos[2]]
    end
  end
end
