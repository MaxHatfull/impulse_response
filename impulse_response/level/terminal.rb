class Level
  class Terminal
    def self.create(parent:, x:, z:, options: [], welcome_clip: nil, powered: true, locked: false)
      ambient_source = Level::SoundSource.create(parent: parent, x: x, z: z, clip: Sounds.terminal, volume: 0.2)
        .component(SoundCastSource)
      terminal_output_source = Level::SoundSource.create(parent: parent, x: x, z: z, clip: nil, beam_length: 10, beam_count: 60, loop: false, play_on_start: false)
        .component(SoundCastSource)

      terminal_controls = TerminalControls.create(
        ambient_source: ambient_source,
        terminal_output_source: terminal_output_source,
        options: options,
        welcome_clip: welcome_clip,
        powered: powered,
        locked: locked
      )

      game_object = Engine::GameObject.create(
        pos: Vector[x, 0, z],
        components: [
          Physics::CircleCollider.create(radius: 2),
          Interacter.create(on_interact: -> { terminal_controls.open }),
          terminal_controls
        ]
      )
      game_object.parent = parent
      game_object
    end
  end
end
