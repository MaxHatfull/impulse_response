class Airlock < Level
  def bounds
    Physics::AABB.new(-10, -16, 10, 5)
  end

  def skybox_color
    Vector[0.75, 0.75, 0.75]  # Light grey
  end

  def create
    puts "loading airlock"

    # Small rectangular room (6m wide x 10m long)
    wall(x: -3, z: -5, width: 1, length: 10)     # left wall
    wall(x: 3, z: -5, width: 1, length: 10)      # right wall
    wall(x: 0, z: 0, width: 6, length: 1)        # back wall (entrance)
    wall(x: 0, z: -10, width: 6, length: 1)      # front wall

    # Door back to Level 1 corridor (behind player spawn)
    door(x: 0, z: -1, level_class: Level1Corridor, level_options: { from: :airlock })

    # Player spawn (facing into room)
    player_spawn(x: 0, z: -2, rotation: 180)
  end
end
