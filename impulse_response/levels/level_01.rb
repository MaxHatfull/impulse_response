class Level01
  def self.create(map)
    # Outer walls
    map.wall(x: 24.5, z: 0, width: 50, length: 1)      # top
    map.wall(x: 24.5, z: -49, width: 50, length: 1)    # bottom
    map.wall(x: 0, z: -24.5, width: 1, length: 50)     # left
    map.wall(x: 49, z: -24.5, width: 1, length: 50)    # right

    # Interior walls
    map.wall(x: 6, z: -2, width: 1, length: 1)
    map.wall(x: 14, z: -3, width: 1, length: 1)
    map.wall(x: 3, z: -6, width: 1, length: 1)
    map.wall(x: 11, z: -8, width: 1, length: 1)
    map.wall(x: 17, z: -10, width: 1, length: 1)
    map.wall(x: 5, z: -12, width: 1, length: 1)
    map.wall(x: 10, z: -15, width: 1, length: 1)

    # Sound source
    Engine::GameObject.create(
      pos: Vector[4, 0.5, -5],
      components: [
        SoundCastSource.create(beam_length: 20, beam_count: 64)
      ]
    )

    # Player spawn
    map.player_spawn(x: 2, z: -18)
  end
end
