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
    wall(x: -2, z: -28, width: 1, length: 28)    # z=-14 to z=-42
    wall(x: -2, z: -48, width: 1, length: 4)     # z=-46 to z=-50

    # Right wall with gap for Stowage (z=-28 to z=-32)
    wall(x: 2, z: -14, width: 1, length: 28)     # z=0 to z=-28
    wall(x: 2, z: -41, width: 1, length: 18)     # z=-32 to z=-50
    wall(x: 0, z: 0, width: 4, length: 1)        # entrance wall
    wall(x: 0, z: -50, width: 4, length: 1)      # exit wall

    # Airlock corridor (4m wide, 6m long, left side)
    # Gap is at z=-42 to z=-46 on left corridor wall
    wall(x: -5, z: -42, width: 6, length: 1)     # north wall
    wall(x: -5, z: -46, width: 6, length: 1)     # south wall
    wall(x: -8, z: -44, width: 1, length: 4)     # west wall (end)

    # Door to Airlock at end of corridor
    door(x: -7, z: -44, level_class: Airlock, trigger_clip: Sounds::Level1::Door.airlock)

    # MedBay corridor (4m wide, short, left side near spawn)
    # Gap is at z=-11 to z=-13 on left corridor wall, with 45° chamfers
    wall(x: -4.65, z: -10, width: 2, length: 1)   # north wall (stops at x=-3)
    wall(x: -4.65, z: -14, width: 2, length: 1)   # south wall (stops at x=-3)
    wall(x: -6, z: -12, width: 1, length: 4)     # west wall (end)
    wall(x: -3.0, z: -9.07, width: 1, length: 3.1, rotation: -45)  # north chamfer
    wall(x: -3.0, z: -14, width: 1, length: 3.1, rotation: 45)   # south chamfer

    # Door to MedBay at end of corridor
    door(x: -5, z: -12, level_class: MedBay, locked: true, trigger_clip: Sounds::Level1::Door.medbay)

    # Stowage corridor (4m wide, short, right side)
    # Gap is at z=-28 to z=-32 on right corridor wall
    wall(x: 4, z: -28, width: 4, length: 1)      # north wall
    wall(x: 4, z: -32, width: 4, length: 1)      # south wall
    wall(x: 6, z: -30, width: 1, length: 4)      # east wall (end)

    # Door to Stowage at end of corridor
    door(x: 5, z: -30, level_class: Stowage, locked: true, trigger_clip: Sounds::Level1::Door.stowage)

    # Doors
    door(x: 0, z: -48, level_class: Level1Corridor)

    # Player spawn based on where they came from
    case from
    when :airlock
      player_spawn(x: -5, z: -44, rotation: 270)
    when :medbay
      player_spawn(x: -4, z: -12, rotation: 270)
    when :stowage
      player_spawn(x: 4, z: -30, rotation: 90)
    else
      player_spawn(x: 0, z: -6, rotation: 180)
    end
  end
end
