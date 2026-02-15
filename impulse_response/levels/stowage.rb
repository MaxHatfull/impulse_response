class Stowage < Level
  def bounds
    Physics::AABB.new(-11, -16, 11, 5)
  end

  def skybox_color
    Vector[0.2, 0.2, 0.6]  # Navy blue
  end

  def create
    puts "loading stowage"

    # Square room (10m x 10m)
    wall(x: -5, z: -5, width: 1, length: 10)      # left wall
    wall(x: 5, z: -5, width: 1, length: 10)       # right wall
    wall(x: 0, z: 0, width: 10, length: 1)        # back wall (entrance)
    wall(x: 0, z: -10, width: 10, length: 1)      # front wall

    # Pillars in the middle (offset)
    wall(x: -2, z: -4, width: 1, length: 1)       # pillar 1
    wall(x: 1, z: -7, width: 1, length: 1)        # pillar 2

    # Door back to Level 1 corridor
    door(x: 3, z: -1, level_class: Level1Corridor, level_options: { from: :stowage }, trigger_clip: Sounds::Level1::Door.corridor_trigger)

    # Circuit panel - controls power to devices on Level 1
    # Power budget: 4, 7 devices total
    circuit_panel(
      x: -3, z: -8,
      total_power: 4,
      welcome_clip: Sounds::CircuitPanel.welcome_power_4,
      devices: [
        {
          name_audio: Sounds::StowageRoom::CircuitPanel.airlock_interior_door,
          device: CallbackDevice.new(
            powered: true,
            on_power_on: -> { GameState.instance.update(airlock_interior_door_powered: true) },
            on_power_off: -> { GameState.instance.update(airlock_interior_door_powered: false) }
          )
        },
        {
          name_audio: Sounds::StowageRoom::CircuitPanel.medbay_diagnostic_pod,
          device: CallbackDevice.new(
            powered: false,
            on_power_on: -> { GameState.instance.update(medbay_diagnostic_pod_powered: true) },
            on_power_off: -> { GameState.instance.update(medbay_diagnostic_pod_powered: false) }
          )
        },
        {
          name_audio: Sounds::StowageRoom::CircuitPanel.medbay_terminal,
          device: CallbackDevice.new(
            powered: false,
            on_power_on: -> { GameState.instance.update(medbay_terminal_powered: true) },
            on_power_off: -> { GameState.instance.update(medbay_terminal_powered: false) }
          )
        },
        {
          name_audio: Sounds::StowageRoom::CircuitPanel.medbay_door,
          device: CallbackDevice.new(
            powered: true,
            on_power_on: -> { GameState.instance.update(medbay_door_powered: true) },
            on_power_off: -> { GameState.instance.update(medbay_door_powered: false) }
          )
        },
        {
          name_audio: Sounds::StowageRoom::CircuitPanel.stowage_door,
          device: CallbackDevice.new(
            powered: true,
            on_power_on: -> { GameState.instance.update(stowage_door_powered: true) },
            on_power_off: -> { GameState.instance.update(stowage_door_powered: false) }
          )
        },
        {
          name_audio: Sounds::StowageRoom::CircuitPanel.door_to_level_0,
          device: CallbackDevice.new(
            powered: true,
            on_power_on: -> { GameState.instance.update(door_to_level_0_powered: true) },
            on_power_off: -> { GameState.instance.update(door_to_level_0_powered: false) }
          )
        },
        {
          name_audio: Sounds::StowageRoom::CircuitPanel.door_to_level_2,
          device: CallbackDevice.new(
            powered: false,
            on_power_on: -> { GameState.instance.update(door_to_level_2_powered: true) },
            on_power_off: -> { GameState.instance.update(door_to_level_2_powered: false) }
          )
        }
      ]
    )

    # Player spawn in corner (facing into room)
    player_spawn(x: 3, z: -4, rotation: 180)
  end
end
