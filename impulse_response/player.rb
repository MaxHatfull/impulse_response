class Player
  include Singleton

  CAMERA_HEIGHT = 0.5

  def spawn
    @game_object = Engine::GameObject.create(
      name: "Player",
      pos: Vector[0, 0, 0],
      components: [
        PlayerController.create(move_speed: 5.0, look_sensitivity: 0.3),
        Physics::CircleCollider.create(radius: 0.5),
        SoundCastSource.create(beam_length: 500, beam_color: [1, 1, 1])
      ]
    )

    Engine::GameObject.create(
      name: "Camera",
      pos: Vector[0, CAMERA_HEIGHT, 0],
      rotation: Vector[0, 180, 0],
      parent: @game_object,
      components: [
        Engine::Components::PerspectiveCamera.create(
          fov: 45.0,
          aspect: 1920.0 / 1080.0,
          near: 0.1,
          far: 1000.0
        )
      ]
    )
    @game_object
  end

  def reset(pos)
    @game_object.pos = pos
    @game_object.rotation = Engine::Quaternion.from_euler(Vector[0, 0, 0])
  end
end
