class Map
  include Singleton

  def load_level(level_class, level_options: {})
    @level_root&.destroy!
    @level_root = Engine::GameObject.create(name: "Level Root")
    level = level_class.new(@level_root)
    Physics.set_bounds(level.bounds)
    level.create(**level_options)
  end
end
