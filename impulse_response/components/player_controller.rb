class PlayerController < Engine::Component
  serialize :move_speed, :look_sensitivity

  def awake
    @enabled = true
  end

  def update(delta_time)
    return unless @enabled

    handle_look
    handle_movement(delta_time)
    resolve_collisions
    handle_click
  end

  def enable
    @enabled = true
  end

  def disable
    @enabled = false
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
    movement = world_direction * @move_speed * delta_time

    game_object.pos = game_object.pos + movement
  end

  def resolve_collisions
    return unless collider

    Physics.collisions(collider, tag: :wall).each do |collision|
      # Push player out of collision along the normal
      push = collision.normal * collision.penetration
      game_object.pos = game_object.pos - Vector[push[0], 0, push[1]]
    end
  end

  def collider
    @collider ||= game_object.component(Physics::CircleCollider)
  end

  def handle_click
    return unless Engine::Input.key_down?(Engine::Input::KEY_SPACE)

    game_object.component(SoundCastSource)&.play
  end
end
