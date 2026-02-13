class CryoRoomLevel < Level
  # Octagon with radius 10 centered at origin
  # Adding ~5m padding
  def bounds
    Physics::AABB.new(-15, -15, 15, 15)
  end

  def create
    # Octagon room - radius 10m, centered at origin
    octagon_walls(center_x: 0, center_z: 0, radius: 10)

    # Door starts locked and unpowered
    exit_door = door(x: 0, z: -8, level_class: Level0Corridor, powered: false, locked: true)
      .component(::Door)

    # Terminal starts powered but locked
    cryo_terminal = terminal(
      x: 0,
      z: 0,
      powered: true,
      locked: true,
      welcome_clip: NativeAudio::Clip.new("impulse_response/assets/audio/cryo_room/terminal/Health Check complete 2.wav"),
      options: [
        {
          menu_item: NativeAudio::Clip.new("impulse_response/assets/audio/cryo_room/terminal/Ship Status.wav"),
          on_select_clip: NativeAudio::Clip.new("impulse_response/assets/audio/cryo_room/terminal/Ship Status Result - Terminal only.wav"),
          on_select_player_clip: NativeAudio::Clip.new("impulse_response/assets/audio/cryo_room/terminal/Ship Status Result - Quinn only.wav")
        },
        {
          menu_item: NativeAudio::Clip.new("impulse_response/assets/audio/cryo_room/terminal/Crew Status.wav"),
          on_select_clip: NativeAudio::Clip.new("impulse_response/assets/audio/cryo_room/terminal/Crew Status Result - Terminal only.wav"),
          on_select_player_clip: NativeAudio::Clip.new("impulse_response/assets/audio/cryo_room/terminal/Crew Status Result - Quinn only.wav")
        },
        {
          menu_item: NativeAudio::Clip.new("impulse_response/assets/audio/cryo_room/terminal/CryoPod Status.wav"),
          on_select_clip: NativeAudio::Clip.new("impulse_response/assets/audio/cryo_room/terminal/Cryopod status Result.wav")
        },
        {
          menu_item: NativeAudio::Clip.new("impulse_response/assets/audio/cryo_room/terminal/Emergency Cryopod override.wav"),
          on_select_clip: NativeAudio::Clip.new("impulse_response/assets/audio/cryo_room/terminal/Emergency Cryopod Override result - Terminal only.wav"),
          on_select_player_clip: NativeAudio::Clip.new("impulse_response/assets/audio/cryo_room/terminal/Emergency Cryopod Override result - Quinn only.wav")
        }
      ]
    ).component(::TerminalControls)

    # Circuit panel to control power, starts locked
    cryo_circuit_panel = circuit_panel(
      x: 5, z: 0,
      total_power: 1,
      locked: true,
      welcome_clip: Sounds::CircuitPanel.welcome,
      devices: [
        {
          name_audio: NativeAudio::Clip.new("impulse_response/assets/audio/cryo_room/circuit_panel/main_door.wav"),
          device: exit_door
        },
        {
          name_audio: NativeAudio::Clip.new("impulse_response/assets/audio/cryo_room/circuit_panel/terminal.wav"),
          device: cryo_terminal
        }
      ]
    ).component(::CircuitPanel)

    # Tutorial sound source at terminal position
    tutorial_source = sound_source(x: 0, z: 0, clip: nil, loop: false, play_on_start: false)
      .component(SoundCastSource)

    Engine::GameObject.create(
      components: [Tutorial.create(
        terminal_source: tutorial_source,
        on_complete: -> {
          cryo_terminal.unlock
          cryo_circuit_panel.unlock
          exit_door.unlock
        }
      )]
    )

    # Player spawn near wall, facing terminal
    player_spawn(x: 0, z: 8, rotation: 180)
  end

  private

  def octagon_walls(center_x:, center_z:, radius:)
    # Regular octagon: 8 walls at 45° increments
    # Wall center is at distance r * cos(π/8) from center
    # Wall length is 2 * r * sin(π/8)
    wall_distance = radius * Math.cos(Math::PI / 8)
    wall_length = 2 * radius * Math.sin(Math::PI / 8)

    8.times do |i|
      angle = i * 45  # degrees
      angle_rad = angle * Math::PI / 180

      # Wall center position
      wall_x = center_x + wall_distance * Math.sin(angle_rad)
      wall_z = center_z - wall_distance * Math.cos(angle_rad)

      # Wall rotation: perpendicular to radial direction
      wall_rotation = angle

      wall(x: wall_x, z: wall_z, width: wall_length, length: 1, rotation: wall_rotation)
    end
  end
end
