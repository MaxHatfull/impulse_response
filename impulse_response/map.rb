class Map
  include Singleton

  attr_reader :grid

  def load_level(path)
    @level_root&.destroy!
    @level_root = Engine::GameObject.create(name: "Level Root")

    wall_material = Engine::Material.create(shader: Engine::Shader.default)
    wall_material.set_vec3("baseColour", Vector[1.0, 0.7, 0.5])
    wall_material.set_texture("image", nil)
    wall_material.set_texture("normalMap", nil)
    wall_material.set_float("diffuseStrength", 0.5)
    wall_material.set_float("specularStrength", 0.3)
    wall_material.set_float("specularPower", 32.0)
    wall_material.set_vec3("ambientLight", Vector[0.02, 0.02, 0.02])
    wall_material.set_float("roughness", 0.6)

    rows = CSV.read(path).map { |row| row.map { |cell| cell&.strip } }

    @grid = rows.each_with_index.map do |row, row_index|
      row.each_with_index.map do |cell, col_index|
        x = col_index
        z = -row_index
        position = Vector[x, 0, z]
        game_object = nil
        type = MapTile::CELL_TO_TYPE.fetch(cell, :empty)

        case type
        when :wall
          game_object = Engine::StandardObjects::Cube.create(
            pos: Vector[x, 0.5, z],
            material: wall_material,
            components: [Raycast::RectCollider.create(center: Vector[x, z], width: 1, height: 1)]
          )
          game_object.parent = @level_root
        when :player_spawn
          Player.instance.reset(position)
        end

        MapTile.new(position: position, game_object: game_object, type: type)
      end
    end
  end

  def tile_at(position)
    col = position[0].round
    row = -position[2].round
    return nil if row < 0 || row >= @grid.length
    return nil if col < 0 || col >= @grid[row].length

    @grid[row][col]
  end
end
