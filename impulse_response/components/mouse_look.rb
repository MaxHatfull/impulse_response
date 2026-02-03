# frozen_string_literal: true

class MouseLook < Engine::Component
  serialize :sensitivity

  def update(delta_time)
    delta = Engine::Input.mouse_delta
    # Only rotate around Y axis (left/right), ignore vertical mouse movement
    game_object.rotation *= Engine::Quaternion.from_euler(Vector[0, delta[0], 0] * @sensitivity)
  end
end
