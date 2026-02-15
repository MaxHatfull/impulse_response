class AlarmLights < Engine::Component
  FLASH_DURATION = 27.0
  LERP_TIME = SkyboxController::LERP_DURATION

  serialize :alarm_color

  def awake
    @elapsed = 0.0
    @next_toggle = LERP_TIME
    @is_alarm_color = true
    Skybox.instance.set_color(@alarm_color)
  end

  def update(delta_time)
    return if @finished

    @elapsed += delta_time

    if @elapsed >= FLASH_DURATION
      @finished = true
      Skybox.instance.set_color(Vector[0.8, 0.8, 0.4])  # Neutral yellow
      return
    end

    if @elapsed >= @next_toggle
      @is_alarm_color = !@is_alarm_color
      if @is_alarm_color
        Skybox.instance.set_color(@alarm_color)
      else
        Skybox.instance.set_color(Vector[0, 0, 0])
      end
      @next_toggle += LERP_TIME
    end
  end
end
