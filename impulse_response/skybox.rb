class Skybox
  include Singleton

  def spawn
    @game_object = Engine::GameObject.create(
      name: "Skybox",
      components: [
        SkyboxController.create
      ]
    )
  end

  def set_color(color)
    spawn unless @game_object
    @game_object.component(SkyboxController).set_color(color)
  end
end
