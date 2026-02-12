class TerminalControls < Engine::Component
  serialize :ambient_source, :terminal_output_source, :options, :welcome_clip, :powered

  attr_reader :powered

  def start
    @open = false
    @state = :idle
    @powered = true if @powered.nil?
    update_ambient_pitch
  end

  def update(delta_time)
    return unless @open

    close if Engine::Input.key_down?(Engine::Input::KEY_Q)

    handle_menu_input if @state == :menu

    return if playing?

    if @state == :welcome || @state == :selected
      @state = :menu
      play_clip(current_option[:menu_item])
    end
  end

  def handle_menu_input
    if Engine::Input.key_down?(Engine::Input::KEY_E)
      @state = :selected
      current_option[:on_select]&.call
      play_clip(current_option[:on_select_clip]) if current_option[:on_select_clip]
    elsif Engine::Input.key_down?(Engine::Input::KEY_W)
      @current_menu_index = (@current_menu_index - 1) % @options.length
      play_clip(current_option[:menu_item])
    elsif Engine::Input.key_down?(Engine::Input::KEY_S)
      @current_menu_index = (@current_menu_index + 1) % @options.length
      play_clip(current_option[:menu_item])
    end
  end

  def current_option
    @options[@current_menu_index]
  end

  def open
    return unless @powered

    @open = true
    @state = :welcome
    @current_menu_index = 0
    @ambient_source.stop
    Player.instance.disable_controls
    play_clip(@welcome_clip) if @welcome_clip
  end

  def close
    @open = false
    @ambient_source.play if @powered
    Player.instance.enable_controls
  end

  def open?
    @open
  end

  def power_on
    @powered = true
    update_ambient_pitch
  end

  def power_off
    @powered = false
    update_ambient_pitch
  end

  def update_ambient_pitch
    return unless @ambient_source

    @ambient_source.set_pitch(@powered ? 1.0 : 0.5)
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
