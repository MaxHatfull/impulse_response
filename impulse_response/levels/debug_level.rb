class DebugLevel < Level
  def bounds
    Physics::AABB.new(-1, -50, 50, 1)
  end

  def create
    # Outer walls
    wall(x: 24.5, z: 0, width: 50, length: 1)      # top
    wall(x: 24.5, z: -49, width: 50, length: 1)    # bottom
    wall(x: 0, z: -24.5, width: 1, length: 50)     # left
    wall(x: 49, z: -24.5, width: 1, length: 50)    # right

    # Interior walls
    wall(x: 10, z: -15, width: 1, length: 1)

    # Sound sources
    sound_source(x: 10, z: -5, clip: Sounds.debug_1)
    sound_source(x: 30, z: -10, clip: Sounds.debug_1)
    sound_source(x: 40, z: -30, clip: Sounds.debug_3)
    sound_source(x: 5, z: -40, clip: Sounds.debug_5)

    # Player spawn
    player_spawn(x: 2, z: -18)
  end
end
