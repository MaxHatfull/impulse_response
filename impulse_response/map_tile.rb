class MapTile
  CELL_TO_TYPE = {
    "x" => :wall,
    "p" => :player_spawn
  }.freeze

  TYPES = (CELL_TO_TYPE.values + [:empty]).freeze

  attr_reader :position, :game_object, :type

  def initialize(position:, game_object:, type:)
    @position = position
    @game_object = game_object
    @type = type

    raise ArgumentError, "Invalid tile type: #{type}" unless TYPES.include?(type)
  end

  def can_step_on?
    @type != :wall
  end
end
