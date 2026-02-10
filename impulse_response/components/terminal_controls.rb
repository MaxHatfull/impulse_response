class TerminalControls < Engine::Component
  serialize :ambient_source, :terminal_output_source, :options, :welcome_clip

  def awake
    @open = false
    @state = :idle
  end

  def update(delta_time)
    return unless @open

    close if Engine::Input.key_down?(Engine::Input::KEY_Q)

    return if playing?

    if @state == :welcome
      @state = :menu
      play_clip(@options.first[:menu_item]) if @options.any?
    end
  end

  def open
    @open = true
    @state = :welcome
    @ambient_source.stop
    Player.instance.disable_controls
    play_clip(@welcome_clip) if @welcome_clip
  end

  def close
    @open = false
    @ambient_source.play
    Player.instance.enable_controls
  end

  def open?
    @open
  end

  def play_clip(clip)
    @terminal_output_source.set_clip(clip)
    @terminal_output_source.play
    @clip_end_time = Time.now + clip.duration
  end

  def playing?
    @clip_end_time && Time.now < @clip_end_time
  end
end
