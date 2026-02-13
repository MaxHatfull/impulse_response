class Level
  class Door
    def self.create(parent:, x:, z:, level_class:, radius: 2, powered: true, locked: false, trigger_clip: nil)
      ambient_source = Level::SoundSource.create(parent: parent, x: x, z: z, clip: Sounds.door_ambient)
        .component(SoundCastSource)
      effect_source = Level::SoundSource.create(parent: parent, x: x, z: z, clip: nil, loop: false, play_on_start: false)
        .component(SoundCastSource)

      door_component = ::Door.create(
        powered: powered,
        locked: locked,
        sound_source: effect_source,
        ambient_source: ambient_source,
        on_open: -> { Map.instance.load_level(level_class) }
      )

      components = [
        Physics::CircleCollider.create(radius: radius),
        Interacter.create(on_interact: -> { door_component.try_open }),
        door_component
      ]

      if trigger_clip
        trigger_source = Level::SoundSource.create(parent: parent, x: x, z: z, clip: nil, loop: false, play_on_start: false)
          .component(SoundCastSource)
        components << PlayerTrigger.create(on_enter: -> {
          trigger_source.set_clip(trigger_clip)
          trigger_source.play
        })
      end

      game_object = Engine::GameObject.create(
        pos: Vector[x, 0, z],
        components: components
      )
      game_object.parent = parent
      game_object
    end
  end
end
