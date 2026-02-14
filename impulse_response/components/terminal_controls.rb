class TerminalControls < Engine::Component
  serialize :ambient_source, :terminal_output_source, :options, :welcome_clips, :powered, :locked

  attr_reader :powered

  def start
    @open = false
    @state = :idle
    @powered = true if @powered.nil?
    @welcome_clips ||= []
    update_ambient_pitch
  end

  def update(delta_time)
    return unless @open

    close if Engine::Input.key_down?(Engine::Input::KEY_Q)

    @audio_queue.update

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
      play_player_clip(current_option[:on_select_player_clip]) if current_option[:on_select_player_clip]
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
    return if @locked

    unless @powered
      @terminal_output_source.set_clip(Sounds::Terminal.insufficient_power)
      @terminal_output_source.play
      return
    end

    @open = true
    @state = :welcome
    @current_menu_index = 0
    @audio_queue = AudioQueue.new(@terminal_output_source)
    @ambient_source.stop
    Player.instance.disable_controls
    @audio_queue.queue(*@welcome_clips) if @welcome_clips.any?
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

  def unlock
    @locked = false
  end

  def update_ambient_pitch
    return unless @ambient_source

    @ambient_source.set_pitch(@powered ? 1.0 : 0.5)
  end

  def play_clip(clip)
    @audio_queue.interrupt
    @audio_queue.queue(clip)
  end

  def play_player_clip(clip)
    Player.instance.voice_source.set_clip(clip)
    Player.instance.voice_source.play
    @player_clip_end_time = Time.now + clip.duration
  end

  def playing?
    queue_playing = @audio_queue&.playing? || false
    player_playing = @player_clip_end_time && Time.now < @player_clip_end_time
    queue_playing || player_playing
  end
end
