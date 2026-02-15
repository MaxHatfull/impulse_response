class Level1Corridor < Level
  # Level spans x: -10.5 to +10.5, z: 0.5 to -50.5
  # Adding ~5m padding
  def bounds
    Physics::AABB.new(-16, -56, 16, 6)
  end

  def skybox_color
    Vector[0.4, 0.4, 0.4]  # Darkish grey
  end

  def create(from: nil)
    puts "loading level 1"

    # Basic corridor - 4m wide, 50m long
    # Left wall with gaps for MedBay (z=-10 to z=-14) and Airlock (z=-42 to z=-46)
    wall(x: -2, z: -3.8, width: 1, length: 9)     # z=0 to z=-10
    wall(x: -2, z: -28, width: 1, length: 24.75)    # z=-16 to z=-40 (between chamfers)
    wall(x: -2, z: -49.15, width: 1, length: 3)     # z=-46 to z=-50

    # Right wall with gap for Stowage (z=-28 to z=-32), with 45° chamfers
    wall(x: 2, z: -13, width: 1, length: 26.58)     # z=0 to z=-26 (before north chamfer)
    wall(x: 2, z: -42, width: 1, length: 16.58)     # z=-34 to z=-50 (after south chamfer)
    wall(x: 0, z: 0, width: 4, length: 1)        # entrance wall
    wall(x: 0, z: -50, width: 4, length: 1)      # exit wall

    # Airlock corridor (4m wide, 6m long, left side)
    # Gap is at z=-42 to z=-46 on left corridor wall, with 45° chamfers
    wall(x: -5.65, z: -42, width: 4, length: 1)   # north wall (stops at x=-3.65)
    wall(x: -5.65, z: -46, width: 4, length: 1)   # south wall (stops at x=-3.65)
    wall(x: -8, z: -44, width: 1, length: 4)      # west wall (end)
    wall(x: -3.0, z: -41.1, width: 1, length: 3.1, rotation: -45)  # north chamfer
    wall(x: -3.0, z: -46.93, width: 1, length: 3.1, rotation: 45)    # south chamfer

    # Door to Airlock at end of corridor
    # Powered state controlled by stowage circuit panel, locked until terminal unlocks it
    airlock_door_locked = !GameState.instance.get(:airlock_door_unlocked)
    airlock_door = door(x: -7, z: -44, level_class: Airlock, trigger_clip: Sounds::Level1::Door.airlock, powered: GameState.instance.get(:airlock_interior_door_powered), locked: airlock_door_locked)
      .component(::Door)

    # Airlock terminal - controls inner door lock (near south chamfer)
    terminal(
      x: -4.5, z: -45,
      welcome_clips: [Sounds::Level1::Terminal.welcome],
      options: [
        {
          menu_item: Sounds::Level1::Terminal.airlock_status,
          on_select_clip: Sounds::Level1::Terminal.airlock_status_result
        },
        {
          menu_item: Sounds::Level1::Terminal.crew_status,
          on_select_clip: Sounds::Level1::Terminal.crew_status_result_terminal,
          on_select_player_clip: Sounds::Level1::Terminal.crew_status_result_player
        },
        {
          menu_item: Sounds::Level1::Terminal.eva_suit_status,
          on_select_clip: Sounds::Level1::Terminal.eva_suit_status_result
        },
        {
          menu_item: Sounds::Level1::Terminal.depressurize,
          on_select_clip: Sounds::Level1::Terminal.depressurize_result
        },
        {
          menu_item: Sounds::Level1::Terminal.outer_door,
          on_select_clip: Sounds::Level1::Terminal.outer_door_result
        },
        {
          menu_item: Sounds::Level1::Terminal.inner_door,
          on_select_clip: Sounds::Level1::Terminal.inner_door_result_terminal,
          on_select_player_clip: Sounds::Level1::Terminal.inner_door_result_player,
          on_select: -> {
            airlock_door.unlock
            GameState.instance.update(airlock_door_unlocked: true)
          }
        }
      ]
    )

    # MedBay corridor (4m wide, short, left side near spawn)
    # Gap is at z=-11 to z=-13 on left corridor wall, with 45° chamfers
    wall(x: -4.65, z: -10, width: 2, length: 1)   # north wall (stops at x=-3)
    wall(x: -4.65, z: -14, width: 2, length: 1)   # south wall (stops at x=-3)
    wall(x: -6, z: -12, width: 1, length: 4)     # west wall (end)
    wall(x: -3.0, z: -9.07, width: 1, length: 3.1, rotation: -45)  # north chamfer
    wall(x: -3.0, z: -14.9, width: 1, length: 3.1, rotation: 45)   # south chamfer

    # Door to MedBay at end of corridor
    # Powered state controlled by stowage circuit panel
    door(x: -5, z: -12, level_class: MedBay, locked: true, trigger_clip: Sounds::Level1::Door.medbay, powered: GameState.instance.get(:medbay_door_powered))

    # Stowage corridor (4m wide, short, right side)
    # Gap is at z=-28 to z=-32 on right corridor wall, with 45° chamfers
    wall(x: 4.65, z: -28, width: 2, length: 1)   # north wall (stops at x=3.65)
    wall(x: 4.65, z: -32, width: 2, length: 1)   # south wall (stops at x=3.65)
    wall(x: 6, z: -30, width: 1, length: 4)      # east wall (end)
    wall(x: 3.0, z: -27.07, width: 1, length: 3.1, rotation: 45)   # north chamfer
    wall(x: 3.0, z: -32.9, width: 1, length: 3.1, rotation: -45)   # south chamfer

    # Door to Stowage at end of corridor
    door(x: 5, z: -30, level_class: Stowage, trigger_clip: Sounds::Level1::Door.stowage)

    # Door to Level 2
    # Powered state controlled by stowage circuit panel
    door(x: 0, z: -48, level_class: Level1Corridor, powered: GameState.instance.get(:door_to_level_2_powered))

    # Player spawn based on where they came from
    case from
    when :airlock
      player_spawn(x: -3, z: -44, rotation: 270)
    when :medbay
      player_spawn(x: -4, z: -12, rotation: 270)
    when :stowage
      player_spawn(x: 4, z: -30, rotation: 90)
    else
      player_spawn(x: 0, z: -6, rotation: 180)
    end

    # Play intro voiceline on first entry
    unless GameState.instance.get(:level_1_intro_played)
      GameState.instance.update(level_1_intro_played: true)
      Player.instance.voice_source.set_clip(Sounds::Level1::Corridor.entry_trigger)
      Player.instance.voice_source.play
    end
  end
end
