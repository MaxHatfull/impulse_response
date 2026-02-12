class Level
  class Door
    def self.create(parent:, x:, z:, level_class:, radius: 2, powered: true, locked: false)
      Level::SoundSource.create(parent: parent, x: x, z: z, clip: Sounds.door_ambient)
      effect_source = Level::SoundSource.create(parent: parent, x: x, z: z, clip: nil, loop: false, play_on_start: false)
        .component(SoundCastSource)

      door_component = ::Door.create(
        powered: powered,
        locked: locked,
        sound_source: effect_source,
        on_open: -> { Map.instance.load_level(level_class) }
      )

      game_object = Engine::GameObject.create(
        pos: Vector[x, 0, z],
        components: [
          Physics::CircleCollider.create(radius: radius),
          Interacter.create(on_interact: -> { door_component.try_open }),
          door_component
        ]
      )
      game_object.parent = parent
      game_object
    end
  end
end
