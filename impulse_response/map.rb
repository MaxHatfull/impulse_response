class Map
  include Singleton

  def load_level(level_class, level_options: {})
    @level_root&.destroy!
    @level_root = Engine::GameObject.create(name: "Level Root")
    level = level_class.new(@level_root)
    Physics.set_bounds(level.bounds)
    set_skybox(level.skybox_color)
    level.create(**level_options)
  end

  private

  def set_skybox(color)
    dim_color = color * 0.3
    Rendering::RenderPipeline.set_skybox_colors(
      ground: dim_color,
      horizon: dim_color,
      sky: color
    )
  end
end
