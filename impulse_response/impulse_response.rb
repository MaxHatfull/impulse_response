# frozen_string_literal: true

require "ruby_rpg"

Engine.start do
  # Camera - required for rendering
  Engine::GameObject.create(
    name: "Camera",
    pos: Vector[0, 0, 0],
    components: [
      Engine::Components::PerspectiveCamera.create(
        fov: 45.0,
        aspect: 1920.0 / 1080.0,
        near: 0.1,
        far: 1000.0
      )
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

  # A simple sphere in front of the camera
  Engine::StandardObjects::Sphere.create(pos: Vector[0, 0, -10])
end
