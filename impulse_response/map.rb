class Map
  include Singleton

  def load_level(path)
    @level_root&.destroy!

    @level_root = Engine::GameObject.create(name: "Level Root")

    rows = CSV.read(path)

    rows.each_with_index do |row, row_index|
      row.each_with_index do |cell, col_index|
        cell = cell&.strip
        x = col_index
        z = -row_index

        case cell
        when "x"
          cube = Engine::StandardObjects::Cube.create(pos: Vector[x, 0.5, z])
          cube.parent = @level_root
        when "p"
          Player.instance.reset(Vector[x, 0, z])
        end
      end
    end
  end
end
