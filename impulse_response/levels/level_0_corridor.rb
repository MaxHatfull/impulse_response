class Level0Corridor < Level
  def create
    # Long corridor - 4m wide, 40m long
    wall(x: -2, z: -20, width: 1, length: 40)  # left wall
    wall(x: 2, z: -20, width: 1, length: 40)   # right wall
    wall(x: 0, z: 0, width: 4, length: 1)      # back wall (entrance)
    wall(x: 0, z: -40, width: 4, length: 1)    # far wall

    # Door at far end leading to cargo bay
    door(x: 0, z: -38, level_class: CargoBayLevel)

    # Player spawn at entrance, facing down corridor
    player_spawn(x: 0, z: -2, rotation: 180)
  end
end
