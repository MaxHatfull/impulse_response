require_relative "loader"

Engine.start do
  Engine::Cursor.disable

  Player.instance.spawn
  Scenery.instance.create_ground
  Map.instance.load_level("impulse_response/levels/01.csv")
end
