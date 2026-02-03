# frozen_string_literal: true

require "ruby_rpg"
require_relative "scenery"
require_relative "components/player_controller"

Engine.start do
  Engine::Cursor.disable

  # Navy twilight sky
  Rendering::RenderPipeline.set_skybox_colors(
    ground: Vector[0.02, 0.02, 0.05],
    horizon: Vector[0.08, 0.06, 0.15],
    sky: Vector[0.05, 0.05, 0.18]
  )

  # Camera - at y=0.5, looking forward
  Engine::GameObject.create(
    name: "Camera",
    pos: Vector[0, 0.5, 0],
    components: [
      Engine::Components::PerspectiveCamera.create(
        fov: 45.0,
        aspect: 1920.0 / 1080.0,
        near: 0.1,
        far: 1000.0
      ),
      PlayerController.create(move_speed: 5.0, look_sensitivity: 0.3)
    ]
  )

  # Light - required to see 3D objects
  Engine::GameObject.create(
    name: "Direction Light",
    rotation: Vector[-60, 180, 30],
    components: [
      Engine::Components::DirectionLight.create(colour: Vector[1.4, 1.4, 1.2])
    ]
  )

  Scenery.create_ground
end
