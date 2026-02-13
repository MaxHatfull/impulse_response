class TapController < Engine::Component
  def awake
    @enabled = true
  end

  def update(delta_time)
    return unless @enabled
    return unless Engine::Input.key_down?(Engine::Input::KEY_SPACE) ||
      Engine::Input.key_down?(Engine::Input::MOUSE_BUTTON_LEFT)

    game_object.component(SoundCastSource)&.play
  end

  def enable
    @enabled = true
  end

  def disable
    @enabled = false
  end
end
