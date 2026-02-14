class Stowage < Level
  def bounds
    Physics::AABB.new(-15, -15, 15, 15)
  end

  def create
    puts "loading stowage"

    # Player spawn
    player_spawn(x: 0, z: -2, rotation: 180)
  end
end
