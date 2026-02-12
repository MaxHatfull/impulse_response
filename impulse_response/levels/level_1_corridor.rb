class Level1Corridor < Level
  # Level spans x: -10.5 to +10.5, z: 0.5 to -50.5
  # Adding ~5m padding
  def bounds
    Physics::AABB.new(-16, -56, 16, 6)
  end

  def create
    puts "loading level 1"

    # Basic corridor - 4m wide, 50m long
    # Left wall with gaps for Airlock (z=-10 to z=-18) and MedBay (z=-26 to z=-34)
    wall(x: -2, z: -5, width: 1, length: 10)     # z=0 to z=-10
    wall(x: -2, z: -22, width: 1, length: 8)     # z=-18 to z=-26
    wall(x: -2, z: -42, width: 1, length: 16)    # z=-34 to z=-50

    # Right wall with gap for Stowage (z=-38 to z=-46)
    wall(x: 2, z: -19, width: 1, length: 38)     # z=0 to z=-38
    wall(x: 2, z: -48, width: 1, length: 4)      # z=-46 to z=-50
    wall(x: 0, z: 0, width: 4, length: 1)        # entrance wall
    wall(x: 0, z: -50, width: 4, length: 1)      # exit wall

    # Airlock room (8x8, left side)
    # Gap is at z=-10 to z=-18 on left corridor wall
    wall(x: -10, z: -14, width: 1, length: 8)    # west wall
    wall(x: -5.5, z: -10, width: 8, length: 1)   # north wall (x=-9.5 to x=-1.5)
    wall(x: -5.5, z: -18, width: 8, length: 1)   # south wall (x=-9.5 to x=-1.5)

    # MedBay room (8x8, left side)
    # Gap is at z=-26 to z=-34 on left corridor wall
    wall(x: -10, z: -30, width: 1, length: 8)    # west wall
    wall(x: -5.5, z: -26, width: 8, length: 1)   # north wall (x=-9.5 to x=-1.5)
    wall(x: -5.5, z: -34, width: 8, length: 1)   # south wall (x=-9.5 to x=-1.5)

    # Stowage room (8x8, right side)
    # Gap is at z=-38 to z=-46 on right corridor wall
    wall(x: 10, z: -42, width: 1, length: 8)     # east wall
    wall(x: 5.5, z: -38, width: 8, length: 1)    # north wall (x=1.5 to x=9.5)
    wall(x: 5.5, z: -46, width: 8, length: 1)    # south wall (x=1.5 to x=9.5)

    # Doors
    door(x: 0, z: -2, level_class: Level0Corridor)
    door(x: 0, z: -48, level_class: Level1Corridor)

    # Player spawn (away from the door trigger zone)
    player_spawn(x: 0, z: -6, rotation: 180)
  end
end
