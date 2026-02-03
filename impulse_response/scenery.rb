# frozen_string_literal: true

module Scenery
  def self.create_ground
    # Off-white marble material for the floor
    floor_material = Engine::Material.create(shader: Engine::Shader.default)
    floor_material.set_vec3("baseColour", Vector[0.95, 0.93, 0.88])
    floor_material.set_texture("image", nil)
    floor_material.set_texture("normalMap", nil)
    floor_material.set_float("diffuseStrength", 0.5)
    floor_material.set_float("specularStrength", 0.6)
    floor_material.set_float("specularPower", 64.0)
    floor_material.set_vec3("ambientLight", Vector[0.02, 0.02, 0.02])
    floor_material.set_float("roughness", 0.3)

    # Ground plane at y=0
    Engine::StandardObjects::Plane.create(
      pos: Vector[0, 0, 0],
      scale: Vector[100, 100, 100],
      rotation: Vector[90, 0, 0],
      material: floor_material
    )

    # Scatter cubes around (y=0.5 so they sit on the floor)
    cube_positions = [
      Vector[-5, 0.5, -8],
      Vector[3, 0.5, -12],
      Vector[-2, 0.5, -15],
      Vector[6, 0.5, -6],
      Vector[-8, 0.5, -20],
      Vector[4, 0.5, -18],
      Vector[-3, 0.5, -25],
      Vector[7, 0.5, -10]
    ]

    cube_positions.each do |pos|
      Engine::StandardObjects::Cube.create(pos: pos)
    end
  end
end
