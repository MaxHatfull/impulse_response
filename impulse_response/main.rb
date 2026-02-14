require_relative "loader"

Engine.start do
  Engine::Cursor.disable

  Rendering::PostProcessingEffect.add_all([
    Rendering::PostProcessingEffect.ssao(kernel_size: 8, radius: 1.0, bias: 0.025, power: 1.0)
  ])

  unless DEBUG
    Rendering::RenderPipeline.set_skybox_colors(
      ground: Vector[0, 0, 0],
      horizon: Vector[0, 0, 0],
      sky: Vector[0, 0, 0]
    )
  end

  Player.instance.spawn
  Scenery.instance.create_ground
  Map.instance.load_level(Stowage)
end
