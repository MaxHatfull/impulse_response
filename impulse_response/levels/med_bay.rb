class MedBay < Level
  def bounds
    Physics::AABB.new(-21, -24, 21, 5)
  end

  def skybox_color
    Vector[0.2, 0.6, 0.2]  # Dark green
  end

  def create
    puts "loading medbay"

    # Large rectangular room (30m wide x 18m long)
    wall(x: -15, z: -9, width: 1, length: 18)     # left wall
    wall(x: 15, z: -9, width: 1, length: 18)      # right wall
    wall(x: 0, z: 0, width: 30, length: 1)        # back wall (entrance)
    wall(x: 0, z: -18, width: 30, length: 1)      # front wall

    # Door back to Level 1 corridor (behind player spawn)
    door(x: -13, z: -1, level_class: Level1Corridor, level_options: { from: :medbay })

    # Player spawn in corner (facing into room)
    player_spawn(x: -13, z: -3, rotation: 180)
  end
end
