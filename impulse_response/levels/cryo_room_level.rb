class CryoRoomLevel < Level
  # Rectangular room 6m wide (E-W) × 14m long (N-S)
  # Adding ~5m padding
  def bounds
    Physics::AABB.new(-8, -12, 8, 12)
  end

  def skybox_color
    Vector[0.8, 0.4, 0.1]  # Orange
  end

  def create
    # Alarm lights effect - flashes for 10s then settles to yellow
    Engine::GameObject.create(
      name: "AlarmLights",
      components: [AlarmLights.create(alarm_color: skybox_color)]
    )

    # Rectangular room
    rectangular_room(center_x: 0, center_z: 0, width: 6, length: 14)

    # Door starts locked and unpowered
    exit_door = door(x: 0, z: -6, level_class: Level0Corridor, powered: false, locked: true, trigger_clip: Sounds::CryoRoom::Door.corridor, rotation: 0)
      .component(::Door)

    # Terminal starts powered but locked
    cryo_terminal = terminal(
      x: 0,
      z: 0,
      powered: true,
      locked: true,
      welcome_clips: [
        Sounds::CryoRoom::Terminal.welcome,
        Sounds::CryoRoom::Terminal.navigation_tutorial
      ],
      options: [
        {
          menu_item: Sounds::CryoRoom::Terminal.ship_status,
          on_select_clip: Sounds::CryoRoom::Terminal.ship_status_result_terminal,
          on_select_player_clip: Sounds::CryoRoom::Terminal.ship_status_result_player
        },
        {
          menu_item: Sounds::CryoRoom::Terminal.crew_status,
          on_select_clip: Sounds::CryoRoom::Terminal.crew_status_result_terminal,
          on_select_player_clip: Sounds::CryoRoom::Terminal.crew_status_result_player
        },
        {
          menu_item: Sounds::CryoRoom::Terminal.cryopod_status,
          on_select_clip: Sounds::CryoRoom::Terminal.cryopod_status_result
        },
        {
          menu_item: Sounds::CryoRoom::Terminal.emergency_override,
          on_select_clip: Sounds::CryoRoom::Terminal.emergency_override_result_terminal,
          on_select_player_clip: Sounds::CryoRoom::Terminal.emergency_override_result_player
        }
      ]
    ).component(::TerminalControls)

    # Circuit panel to control power, starts locked
    cryo_circuit_panel = circuit_panel(
      x: 2, z: -3,
      total_power: 1,
      locked: true,
      welcome_clip: Sounds::CircuitPanel.welcome,
      devices: [
        {
          name_audio: Sounds::CryoRoom::CircuitPanel.main_door,
          device: exit_door
        },
        {
          name_audio: Sounds::CryoRoom::CircuitPanel.terminal,
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

    # Player spawn near south wall, facing terminal
    player_spawn(x: 0, z: 6, rotation: 180)
  end

  private

  def rectangular_room(center_x:, center_z:, width:, length:)
    half_w = width / 2.0
    half_l = length / 2.0

    wall(x: center_x, z: center_z - half_l, width: width, length: 1, rotation: 0)   # North
    wall(x: center_x, z: center_z + half_l, width: width, length: 1, rotation: 0)   # South
    wall(x: center_x + half_w, z: center_z, width: length, length: 1, rotation: 90) # East
    wall(x: center_x - half_w, z: center_z, width: length, length: 1, rotation: 90) # West
  end
end
