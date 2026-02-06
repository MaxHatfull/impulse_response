class Level01
  def self.create(map)
    # Outer walls
    map.wall(x: 9.5, z: 0, width: 20, length: 1)      # top
    map.wall(x: 9.5, z: -19, width: 20, length: 1)    # bottom
    map.wall(x: 0, z: -9.5, width: 1, length: 20)     # left
    map.wall(x: 19, z: -9.5, width: 1, length: 20)    # right

    # Interior walls
    map.wall(x: 6, z: -2, width: 1, length: 1)
    map.wall(x: 14, z: -3, width: 1, length: 1)
    map.wall(x: 3, z: -6, width: 1, length: 1)
    map.wall(x: 11, z: -8, width: 1, length: 1)
    map.wall(x: 17, z: -10, width: 1, length: 1)
    map.wall(x: 5, z: -12, width: 1, length: 1)
    map.wall(x: 10, z: -15, width: 1, length: 1)

    # Player spawn
    map.player_spawn(x: 2, z: -18)
  end
end
