class Level
  def initialize(level_root)
    @level_root = level_root
  end

  def create
    raise NotImplementedError, "Subclasses must implement #create"
  end

  def bounds
    raise NotImplementedError, "Subclasses must implement #bounds"
  end

  def wall(x:, z:, width:, length:, height: 1, rotation: 0)
    game_object = Engine::StandardObjects::Cube.create(
      pos: Vector[x, height / 2.0, z],
      scale: Vector[width, height, length],
      rotation: Vector[0, rotation, 0],
      material: wall_material,
      components: [Physics::RectCollider.create(width: width, height: length, tags: [:wall])]
    )
    game_object.parent = @level_root
    game_object
  end

  def sound_source(x:, z:, clip: nil, beam_length: 40, beam_count: 64, volume: 10, loop: true, play_on_start: true)
    pos = Vector[x, 0.5, z]
    game_object = Engine::GameObject.create(
      pos: pos,
      components: [
        SoundCastSource.create(
          beam_length: beam_length, beam_count: beam_count, volume: volume,
          clip: clip, loop: loop, play_on_start: play_on_start
        )
      ]
    )
    game_object.parent = @level_root
    Engine::StandardObjects::Sphere.create(pos: pos, parent: @level_root)
    game_object
  end

  def player_spawn(x:, z:, rotation: 0)
    Player.instance.reset(Vector[x, 0, z], rotation: rotation)
  end

  def door(x:, z:, level_class:, radius: 2)
    sound_source(x: x, z: z, clip: Sounds.door)

    game_object = Engine::GameObject.create(
      pos: Vector[x, 0, z],
      components: [
        Physics::CircleCollider.create(radius: radius),
        Interacter.create(on_interact: -> { Map.instance.load_level(level_class) })
      ]
    )
    game_object.parent = @level_root
    game_object
  end

  def terminal(x:, z:, options: [], welcome_clip: nil)
    ambient_source = sound_source(x: x, z: z, clip: Sounds.terminal, volume: 0.2)
      .component(SoundCastSource)
    terminal_output_source = sound_source(x: x, z: z, clip: nil, beam_length: 10, beam_count: 60, loop: false, play_on_start: false)
      .component(SoundCastSource)

    terminal_controls = TerminalControls.create(
      ambient_source: ambient_source,
      terminal_output_source: terminal_output_source,
      options: options,
      welcome_clip: welcome_clip
    )

    game_object = Engine::GameObject.create(
      pos: Vector[x, 0, z],
      components: [
        Physics::CircleCollider.create(radius: 2),
        Interacter.create(on_interact: -> { terminal_controls.open }),
        terminal_controls
      ]
    )
    game_object.parent = @level_root
    game_object
  end

  private

  def wall_material
    @wall_material ||= begin
      material = Engine::Material.create(shader: Engine::Shader.default)
      material.set_vec3("baseColour", Vector[0.9, 0.2, 0.2])
      material.set_texture("image", nil)
      material.set_texture("normalMap", nil)
      material.set_float("diffuseStrength", 0.5)
      material.set_float("specularStrength", 0.3)
      material.set_float("specularPower", 32.0)
      material.set_vec3("ambientLight", Vector[0.02, 0.02, 0.02])
      material.set_float("roughness", 0.6)
      material.set_float("ambientStrength", 0.7)
      material
    end
  end
end
