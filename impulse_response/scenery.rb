module Scenery
  def self.create_ground
    floor_material = Engine::Material.create(shader: Engine::Shader.default)
    floor_material.set_vec3("baseColour", Vector[0.95, 0.93, 0.88])
    floor_material.set_texture("image", nil)
    floor_material.set_texture("normalMap", nil)
    floor_material.set_float("diffuseStrength", 0.5)
    floor_material.set_float("specularStrength", 0.6)
    floor_material.set_float("specularPower", 64.0)
    floor_material.set_vec3("ambientLight", Vector[0.02, 0.02, 0.02])
    floor_material.set_float("roughness", 0.3)

    Engine::StandardObjects::Plane.create(
      pos: Vector[0, 0, 0],
      scale: Vector[100, 100, 100],
      rotation: Vector[90, 0, 0],
      material: floor_material
    )
  end
end
