class MainMenuControls < Engine::Component
  def start
    @current_index = 0
    @options = [
      { name: :start_game, clip: -> { Sounds::MainMenu.start_game } },
      { name: :exit, clip: -> { Sounds::MainMenu.exit_game } }
    ]
    @audio_source = nil
    @clip_end_time = nil
    @started = false

    @music_source = NativeAudio::AudioSource.new(Sounds::MainMenu.music)
    @music_source.set_volume(60)
    @music_source.set_looping(true)
    @music_source.play

    play_clip(Sounds::MainMenu.welcome)
  end

  def update(delta_time)
    return if playing?

    unless @started
      @started = true
      play_clip(current_option[:clip].call)
      return
    end

    handle_input
  end

  def handle_input
    if Engine::Input.key_down?(Engine::Input::KEY_W)
      @current_index = (@current_index - 1) % @options.length
      play_clip(current_option[:clip].call)
    elsif Engine::Input.key_down?(Engine::Input::KEY_S)
      @current_index = (@current_index + 1) % @options.length
      play_clip(current_option[:clip].call)
    elsif Engine::Input.key_down?(Engine::Input::KEY_E)
      select_option
    end
  end

  def select_option
    case current_option[:name]
    when :start_game
      start_game
    when :exit
      # Do nothing for now
    end
  end

  def start_game
    @music_source.set_volume(30)
    Player.instance.enable_controls
    Map.instance.load_level(CryoRoomLevel)
    game_object.destroy!
  end

  private

  def current_option
    @options[@current_index]
  end

  def play_clip(clip)
    @audio_source&.stop
    @audio_source = NativeAudio::AudioSource.new(clip)
    @audio_source.set_volume(100)
    @audio_source.play
    @clip_end_time = Time.now + clip.duration
  end

  def playing?
    @clip_end_time && Time.now < @clip_end_time
  end
end
