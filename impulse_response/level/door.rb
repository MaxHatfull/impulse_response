class Level
  class Door
    def self.create(parent:, x:, z:, level_class:, radius: 1, powered: true, locked: false, locked_clip: nil, trigger_clip: nil, level_options: {}, rotation: 0)
      start_angle = -Math::PI / 2
      end_angle = Math::PI / 2
      ambient_source = Level::SoundSource.create(parent: parent, x: x, z: z, clip: Sounds.door_ambient, volume: 1, beam_count: 32, start_angle: start_angle, end_angle: end_angle)
      ambient_source.rotation = Engine::Quaternion.from_euler(Vector[0, rotation, 0])
      ambient_source = ambient_source.component(SoundCastSource)
      effect_source = Level::SoundSource.create(parent: parent, x: x, z: z, clip: nil, loop: false, play_on_start: false, beam_count: 32, start_angle: start_angle, end_angle: end_angle)
      effect_source.rotation = Engine::Quaternion.from_euler(Vector[0, rotation, 0])
      effect_source = effect_source.component(SoundCastSource)

      door_component = ::Door.create(
        powered: powered,
        locked: locked,
        locked_clip: locked_clip,
        sound_source: effect_source,
        ambient_source: ambient_source,
        on_open: -> { Map.instance.load_level(level_class, level_options: level_options) }
      )

      components = [
        Physics::CircleCollider.create(radius: radius),
        Interacter.create(on_interact: -> { door_component.try_open }),
        door_component
      ]

      if trigger_clip
        trigger_source_go = Level::SoundSource.create(parent: parent, x: x, z: z, clip: nil, loop: false, play_on_start: false, beam_count: 32, start_angle: start_angle, end_angle: end_angle)
        trigger_source_go.rotation = Engine::Quaternion.from_euler(Vector[0, rotation, 0])
        trigger_source = trigger_source_go.component(SoundCastSource)
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
