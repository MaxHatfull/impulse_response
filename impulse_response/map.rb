class Map
  include Singleton

  def load_level(level_class)
    @level_root&.destroy!
    @level_root = Engine::GameObject.create(name: "Level Root")
    level_class.new(@level_root).create
  end
end
