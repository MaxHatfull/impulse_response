class Level0Corridor < Level
  # Level spans x: -2.5 to +2.5, z: 0 to -40.5
  # Adding ~5m padding
  def bounds
    Physics::AABB.new(-8, -46, 8, 6)
  end

  def skybox_color
    Vector[0.4, 0.4, 0.4]  # Darkish grey
  end

  def create
    puts "loading 0"
    # Long corridor - 4m wide, 40m long
    wall(x: -2, z: -20, width: 1, length: 40)  # left wall
    wall(x: 2, z: -20, width: 1, length: 40)   # right wall
    wall(x: 0, z: 0, width: 4, length: 1)      # back wall (entrance)
    wall(x: 0, z: -40, width: 4, length: 1)    # far wall

    # Door at far end leading to Level 1
    door(x: 0, z: -38, level_class: Level1Corridor)

    # Player spawn at entrance, facing down corridor
    player_spawn(x: 0, z: -2, rotation: 180)

    # Play corridor trigger from player voice
    Player.instance.voice_source.set_clip(Sounds::Level0.corridor_trigger)
    Player.instance.voice_source.play
  end
end
