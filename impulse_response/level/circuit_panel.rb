class Level
  class CircuitPanel
    def self.create(parent:, x:, z:, devices: [], welcome_clip: nil, total_power: 1, locked: false)
      ambient_source = Level::SoundSource.create(parent: parent, x: x, z: z, clip: Sounds::CircuitPanel.ambient, volume: 0.5)
        .component(SoundCastSource)
      output_source = Level::SoundSource.create(parent: parent, x: x, z: z, clip: nil, beam_length: 10, beam_count: 60, loop: false, play_on_start: false)
        .component(SoundCastSource)

      circuit_panel = ::CircuitPanel.create(
        ambient_source: ambient_source,
        output_source: output_source,
        welcome_clip: welcome_clip,
        total_power: total_power,
        locked: locked
      )
      circuit_panel.devices = devices

      game_object = Engine::GameObject.create(
        pos: Vector[x, 0, z],
        components: [
          Physics::CircleCollider.create(radius: 1),
          Interacter.create(on_interact: -> { circuit_panel.open }),
          circuit_panel
        ]
      )
      game_object.parent = parent
      game_object
    end
  end
end
