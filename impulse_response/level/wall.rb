class Level
  class Wall
    def self.create(parent:, x:, z:, width:, length:, height: 1, rotation: 0)
      if DEBUG
        game_object = Engine::StandardObjects::Cube.create(
          pos: Vector[x, height / 2.0, z],
          scale: Vector[width, height, length],
          rotation: Vector[0, rotation, 0],
          material: material,
          components: [Physics::RectCollider.create(width: width, height: length, tags: [:wall])]
        )
        game_object.parent = parent
        game_object
      else
        game_object = Engine::GameObject.create(
          pos: Vector[x, height / 2.0, z],
          rotation: Vector[0, rotation, 0],
          components: [Physics::RectCollider.create(width: width, height: length, tags: [:wall])]
        )
        game_object.parent = parent
        game_object
      end
    end

    def self.material
      @material ||= begin
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
end
