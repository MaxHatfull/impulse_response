class Player
  include Singleton

  CAMERA_HEIGHT = 2

  attr_reader :voice_source

  def spawn
    @game_object = Engine::GameObject.create(
      name: "Player",
      pos: Vector[0, 0, 0],
      components: [
        PlayerController.create(move_speed: 4.0, look_sensitivity: 0.3),
        Physics::CircleCollider.create(radius: 0.25, tags: [:player]),
        Physics::CircleCollider.create(radius: 1, tags: [:listener]),
        SoundListener.create
      ]
    )

    @tap_source = Engine::GameObject.create(
      name: "TapSource",
      pos: Vector[0, 0, 0.25],
      parent: @game_object,
      components: [
        TapController.create,
        SoundCastSource.create(
          clip: Sounds.tap,
          beam_count: 64,
          beam_length: 100,
          volume: 120.0,
          loop: false,
          play_on_start: false
        )
      ]
    )

    @voice_source = Engine::GameObject.create(
      name: "VoiceSource",
      pos: Vector[0, 0, 0.01],
      parent: @game_object,
      components: [
        SoundCastSource.create(
          clip: Sounds.tap,
          beam_count: 64,
          beam_length: 100,
          volume: 0.8,
          loop: false,
          play_on_start: false
        )
      ]
    ).component(SoundCastSource)

    Engine::GameObject.create(
      name: "Camera",
      pos: Vector[0, CAMERA_HEIGHT, 0],
      rotation: Vector[20, 180, 0],
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

  def reset(pos, rotation: 0)
    @game_object.pos = pos
    @game_object.rotation = Engine::Quaternion.from_euler(Vector[0, rotation, 0])
  end

  def disable_controls
    @game_object.component(PlayerController).disable
    @tap_source.component(TapController).disable
    Interacter.disable_all
  end

  def enable_controls
    @game_object.component(PlayerController).enable
    @tap_source.component(TapController).enable
    Interacter.enable_all
  end
end
