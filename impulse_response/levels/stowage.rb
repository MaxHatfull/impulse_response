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

    # Player spawn in corner (facing into room)
    player_spawn(x: 3, z: -4, rotation: 180)
  end
end
