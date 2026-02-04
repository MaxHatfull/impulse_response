class PlayerController < Engine::Component
  COLLISION_RADIUS = 0.5

  serialize :move_speed, :look_sensitivity

  def update(delta_time)
    handle_look
    handle_movement(delta_time)
  end

  private

  def handle_look
    delta = Engine::Input.mouse_delta
    game_object.rotation *= Engine::Quaternion.from_euler(Vector[0, delta[0], 0] * @look_sensitivity)
  end

  def handle_movement(delta_time)
    direction = Vector[0, 0, 0]

    direction += Vector[0, 0, 1] if Engine::Input.key?(Engine::Input::KEY_W)
    direction += Vector[0, 0, -1] if Engine::Input.key?(Engine::Input::KEY_S)
    direction += Vector[0.5, 0, 0] if Engine::Input.key?(Engine::Input::KEY_A)
    direction += Vector[-0.5, 0, 0] if Engine::Input.key?(Engine::Input::KEY_D)

    return if direction == Vector[0, 0, 0]

    world_direction = game_object.local_to_world_direction(direction).normalize
    new_pos = game_object.pos + world_direction * @move_speed * delta_time

    return unless can_move?(new_pos)

    game_object.pos = new_pos
  end

  def can_move?(pos)
    8.times.all? do |i|
      angle = i * Math::PI / 4
      check_pos = Vector[
        pos[0] + Math.cos(angle) * COLLISION_RADIUS,
        pos[1],
        pos[2] + Math.sin(angle) * COLLISION_RADIUS
      ]
      tile = Map.instance.tile_at(check_pos)
      tile&.can_step_on?
    end
  end
end
