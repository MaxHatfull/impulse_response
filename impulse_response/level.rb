class Level
  def initialize(level_root)
    @level_root = level_root
  end

  def create
    raise NotImplementedError, "Subclasses must implement #create"
  end

  def wall(x:, z:, width:, length:, height: 1)
    game_object = Engine::StandardObjects::Cube.create(
      pos: Vector[x, height / 2.0, z],
      scale: Vector[width, height, length],
      material: wall_material,
      components: [Physics::RectCollider.create(width: width, height: length, tags: [:wall])]
    )
    game_object.parent = @level_root
    game_object
  end

  def sound_source(x:, z:, clip: nil, beam_length: 40, beam_count: 128, volume: 10)
    pos = Vector[x, 0.5, z]
    game_object = Engine::GameObject.create(
      pos: pos,
      components: [
        SoundCastSource.create(
          beam_length: beam_length, beam_count: beam_count, volume: volume,
          clip_path: clip
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
