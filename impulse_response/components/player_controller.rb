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
    movement = world_direction * @move_speed * delta_time

    # Convert to 2D (x, z) for raycasting
    pos_2d = Vector[game_object.pos[0], game_object.pos[2]]
    movement_2d = Vector[movement[0], movement[2]]
    move_distance = movement_2d.magnitude

    return if move_distance == 0

    ray = Physics::Ray.new(
      start_point: pos_2d,
      direction: movement_2d,
      length: move_distance + COLLISION_RADIUS
    )

    hit = Physics.closest_raycast(ray)

    if hit && hit.distance < move_distance + COLLISION_RADIUS
      # Remove the component of movement going into the wall
      normal_component = movement_2d.dot(hit.normal)
      if normal_component < 0
        movement_2d = movement_2d - hit.normal * normal_component
      end
    end

    # Check if destination is inside any target
    destination_2d = pos_2d + movement_2d
    return if Physics.colliders_at(destination_2d).any?

    # Apply adjusted movement back to 3D
    game_object.pos = game_object.pos + Vector[movement_2d[0], 0, movement_2d[1]]
  end
end
