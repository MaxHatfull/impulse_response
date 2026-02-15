class GameState
  include Singleton

  def initialize
    @state = {}
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
    @state = {}
  end
end
