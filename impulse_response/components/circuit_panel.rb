class CircuitPanel < Engine::Component
  serialize :ambient_source, :output_source, :welcome_clip, :total_power

  attr_accessor :devices

  def awake
    @open = false
    @state = :idle
    @clip_queue = []
    @devices ||= []
  end

  def update(delta_time)
    return unless @open

    close if Engine::Input.key_down?(Engine::Input::KEY_Q)

    process_clip_queue unless playing?

    handle_menu_input if @state == :menu

    return if playing?

    if @state == :welcome || @state == :toggled
      @state = :menu
      announce_current_device
    end
  end

  def handle_menu_input
    if Engine::Input.key_down?(Engine::Input::KEY_E)
      toggle_current_device
    elsif Engine::Input.key_down?(Engine::Input::KEY_W)
      @current_index = (@current_index - 1) % @devices.length
      announce_current_device
    elsif Engine::Input.key_down?(Engine::Input::KEY_S)
      @current_index = (@current_index + 1) % @devices.length
      announce_current_device
    end
  end

  def announce_current_device
    interrupt
    device = current_device[:device]
    status_clip = device.powered ? Sounds::CircuitPanel.powered : Sounds::CircuitPanel.unpowered
    queue_clips(current_device[:name_audio], status_clip)
  end

  def toggle_current_device
    interrupt
    device = current_device[:device]
    @state = :toggled

    if device.powered
      device.power_off
      play_clip(Sounds::CircuitPanel.power_off)
    elsif power_available?
      device.power_on
      play_clip(Sounds::CircuitPanel.power_on)
    else
      play_clip(Sounds::CircuitPanel.insufficient_power)
    end
  end

  def power_available?
    current_usage < @total_power
  end

  def current_usage
    @devices.count { |d| d[:device].powered }
  end

  def current_device
    @devices[@current_index]
  end

  def open
    @open = true
    @state = :welcome
    @current_index = 0
    @clip_queue = []
    @ambient_source.stop
    Player.instance.disable_controls
    play_clip(@welcome_clip) if @welcome_clip
  end

  def close
    @open = false
    @clip_queue = []
    @ambient_source.play
    Player.instance.enable_controls
  end

  def open?
    @open
  end

  def queue_clips(*clips)
    @clip_queue = clips.compact
    process_clip_queue
  end

  def process_clip_queue
    return if @clip_queue.empty?

    clip = @clip_queue.shift
    play_clip(clip)
  end

  def play_clip(clip)
    return unless clip

    @output_source.set_clip(clip)
    @output_source.play
    @clip_end_time = Time.now + clip.duration
  end

  def playing?
    @clip_end_time && Time.now < @clip_end_time
  end

  def interrupt
    @clip_queue = []
    @clip_end_time = nil
  end
end
