class Door < Engine::Component
  serialize :powered, :locked, :sound_source, :on_open

  attr_reader :powered

  def start
    @powered = true if @powered.nil?
    @locked = false if @locked.nil?
  end

  def try_open
    if @locked
      play_clip(Sounds.door_locked)
      return
    end

    unless @powered
      play_clip(Sounds.door_requires_power)
      return
    end

    @on_open&.call
  end

  def unlock
    @locked = false
  end

  def lock
    @locked = true
  end

  def power_on
    @powered = true
  end

  def power_off
    @powered = false
  end

  private

  def play_clip(clip)
    return unless @sound_source

    @sound_source.set_clip(clip)
    @sound_source.play
  end
end
