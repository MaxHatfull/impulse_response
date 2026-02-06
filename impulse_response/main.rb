require_relative "loader"

Engine.start do
  Engine::Cursor.disable

  Rendering::PostProcessingEffect.add_all([
    Rendering::PostProcessingEffect.ssao(kernel_size: 8, radius: 1.0, bias: 0.025, power: 1.0)
  ])

  Player.instance.spawn
  Scenery.instance.create_ground
  Map.instance.load_level(Level01)
end
