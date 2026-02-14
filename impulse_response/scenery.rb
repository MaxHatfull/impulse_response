class Scenery
  include Singleton

  def create_ground
    floor_material = Engine::Material.create(shader: Engine::Shader.default)
    floor_material.set_vec3("baseColour", Vector[0.2, 0.4, 0.9])
    floor_material.set_texture("image", nil)
    floor_material.set_texture("normalMap", nil)
    floor_material.set_float("diffuseStrength", 0.5)
    floor_material.set_float("specularStrength", 0.6)
    floor_material.set_float("specularPower", 64.0)
    floor_material.set_vec3("ambientLight", Vector[0.02, 0.02, 0.02])
    floor_material.set_float("roughness", 0.3)
    floor_material.set_float("ambientStrength", 0.7)

    if DEBUG
      Engine::StandardObjects::Plane.create(
        pos: Vector[0, 0, 0],
        scale: Vector[100, 100, 100],
        rotation: Vector[90, 0, 0],
        material: floor_material
      )
    end

    Engine::GameObject.create(
      name: "Direction Light",
      rotation: Vector[-60, 180, 30],
      components: [
        Engine::Components::DirectionLight.create(colour: Vector[0.8, 0.8, 0.7])
      ]
    )
  end
end
