class GameState
  include Singleton

  def initialize
    @state = {}
  end

  def update(new_state)
    deep_merge(@state, new_state)
  end

  def get(key)
    @state[key]
  end

  def reset
    @state = {}
  end

  private

  def deep_merge(target, source)
    source.each do |key, value|
      if value.is_a?(Hash) && target[key].is_a?(Hash)
        deep_merge(target[key], value)
      else
        target[key] = value
      end
    end
  end
end
