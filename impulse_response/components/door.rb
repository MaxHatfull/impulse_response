class Door < Engine::Component
  serialize :powered, :locked, :locked_clip, :sound_source, :ambient_source, :on_open

  attr_reader :powered

  def start
    @powered = true if @powered.nil?
    @locked = false if @locked.nil?
    @locked_clip ||= Sounds.door_locked
    update_ambient_pitch
  end

  def try_open
    if @locked
      play_clip(@locked_clip)
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
    update_ambient_pitch
  end

  def power_off
    @powered = false
    update_ambient_pitch
  end

  private

  def update_ambient_pitch
    return unless @ambient_source

    @ambient_source.set_pitch(@powered ? 1.0 : 0.5)
  end

  def play_clip(clip)
    return unless @sound_source

    @sound_source.set_clip(clip)
    @sound_source.play
  end
end
