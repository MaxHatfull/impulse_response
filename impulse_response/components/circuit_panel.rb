class CircuitPanel < Engine::Component
  serialize :ambient_source, :output_source, :welcome_clip, :total_power, :locked

  attr_accessor :devices

  def awake
    @open = false
    @state = :idle
    @devices ||= []
  end

  def update(delta_time)
    return unless @open

    close if Engine::Input.key_down?(Engine::Input::KEY_Q)

    @audio_queue.update

    handle_menu_input if @state == :menu

    return if @audio_queue.playing?

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
    @audio_queue.interrupt
    device = current_device[:device]
    status_clip = device.powered ? Sounds::CircuitPanel.powered : Sounds::CircuitPanel.unpowered
    @audio_queue.queue(current_device[:name_audio], status_clip)
  end

  def toggle_current_device
    @audio_queue.interrupt
    device = current_device[:device]
    @state = :toggled

    if device.powered
      device.power_off
      @audio_queue.queue(Sounds::CircuitPanel.power_off)
    elsif power_available?
      device.power_on
      @audio_queue.queue(Sounds::CircuitPanel.power_on)
    else
      @audio_queue.queue(Sounds::CircuitPanel.insufficient_power)
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
    return if @locked

    @open = true
    @state = :welcome
    @current_index = 0
    @audio_queue = AudioQueue.new(@output_source)
    @ambient_source.stop
    Player.instance.disable_controls
    @audio_queue.queue(@welcome_clip) if @welcome_clip
  end

  def close
    @open = false
    @audio_queue.interrupt
    @ambient_source.play
    Player.instance.enable_controls
  end

  def open?
    @open
  end

  def unlock
    @locked = false
  end
end
