class Tutorial < Engine::Component
  serialize :terminal_source, :on_complete

  AWAKENING_TERMINAL = "impulse_response/assets/audio/cryo_room/tutorial/Awakening - Terminal only.wav"
  AWAKENING_PLAYER = "impulse_response/assets/audio/cryo_room/tutorial/Awakening - Quinn only.wav"
  HEALTH_CHECK_EXERCISE_2 = "impulse_response/assets/audio/cryo_room/tutorial/Health Check Exercise 2.wav"
  HEALTH_CHECK_EXERCISE_3_AND_4 = "impulse_response/assets/audio/cryo_room/tutorial/Health Check Exercise 3 and 4.wav"
  HEALTH_CHECK_COMPLETE_1 = "impulse_response/assets/audio/cryo_room/tutorial/Health Check Complete 1.wav"

  def start
    @state = :awakening
    @clip_end_time = nil
    @look_left_time = 0
    @look_right_time = 0

    terminal_clip = NativeAudio::Clip.new(AWAKENING_TERMINAL)
    player_clip = NativeAudio::Clip.new(AWAKENING_PLAYER)

    play_terminal_clip(terminal_clip)
    play_player_clip(player_clip)

    @clip_end_time = Time.now + [terminal_clip.duration, player_clip.duration].max
  end

  def update(delta_time)
    case @state
    when :awakening
      @state = :tracking_look unless playing?
    when :tracking_look
      track_look(delta_time)
    when :exercise_2
      @state = :tracking_movement unless playing?
    when :tracking_movement
      track_movement(delta_time)
    when :exercise_3_and_4
      @state = :waiting_for_tap unless playing?
    when :waiting_for_tap
      check_for_tap
    when :complete
      unless playing?
        @on_complete&.call
        @state = :done
      end
    end
  end

  private

  def track_look(delta_time)
    delta = Engine::Input.mouse_delta
    if delta[0] > 0
      @look_right_time += delta_time
    elsif delta[0] < 0
      @look_left_time += delta_time
    end

    if @look_left_time >= 0.3 && @look_right_time >= 0.3
      clip = NativeAudio::Clip.new(HEALTH_CHECK_EXERCISE_2)
      play_terminal_clip(clip)
      @clip_end_time = Time.now + clip.duration
      @state = :exercise_2
      @w_time = 0
      @a_time = 0
      @s_time = 0
      @d_time = 0
    end
  end

  def track_movement(delta_time)
    @w_time += delta_time if Engine::Input.key?(Engine::Input::KEY_W)
    @a_time += delta_time if Engine::Input.key?(Engine::Input::KEY_A)
    @s_time += delta_time if Engine::Input.key?(Engine::Input::KEY_S)
    @d_time += delta_time if Engine::Input.key?(Engine::Input::KEY_D)

    if @w_time >= 0.1 && @a_time >= 0.1 && @s_time >= 0.1 && @d_time >= 0.1
      clip = NativeAudio::Clip.new(HEALTH_CHECK_EXERCISE_3_AND_4)
      play_terminal_clip(clip)
      @clip_end_time = Time.now + clip.duration
      @state = :exercise_3_and_4
    end
  end

  def check_for_tap
    if Engine::Input.key_down?(Engine::Input::KEY_SPACE) || Engine::Input.key_down?(Engine::Input::MOUSE_BUTTON_LEFT)
      clip = NativeAudio::Clip.new(HEALTH_CHECK_COMPLETE_1)
      play_terminal_clip(clip)
      @clip_end_time = Time.now + clip.duration
      @state = :complete
    end
  end

  def playing?
    @clip_end_time && Time.now < @clip_end_time
  end

  def play_terminal_clip(clip)
    @terminal_source.set_clip(clip)
    @terminal_source.play
  end

  def play_player_clip(clip)
    Player.instance.voice_source.set_clip(clip)
    Player.instance.voice_source.play
  end
end
