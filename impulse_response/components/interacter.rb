class Interacter < Engine::Component
  serialize :on_interact

  def update(delta_time)
    return unless player_colliding?
    return unless Engine::Input.key_down?(Engine::Input::KEY_E)

    @on_interact&.call
  end

  private

  def player_colliding?
    Physics.collisions(collider, tag: :player).any?
  end

  def collider
    @collider ||= game_object.component(Physics::CircleCollider)
  end
end
