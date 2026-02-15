class GameState
  include Singleton

  DEFAULTS = {
    airlock_interior_door_powered: true,
    medbay_diagnostic_pod_powered: false,
    medbay_terminal_powered: false,
    medbay_door_powered: true,
    door_to_level_2_powered: false,
    level_1_intro_played: false
  }.freeze

  def initialize
    @state = DEFAULTS.dup
  end

  def update(new_state)
    @state.merge!(new_state)
  end

  def get(key)
    @state[key]
  end

  def key?(key)
    @state.key?(key)
  end

  def reset
    @state = DEFAULTS.dup
  end
end
