class PlayerTrigger < Engine::Component
  serialize :on_enter

  def start
    @player_inside = false
  end

  def update(delta_time)
    player_colliding = Physics.collisions(collider, tag: :player).any?

    if player_colliding && !@player_inside
      @player_inside = true
      @on_enter&.call
    elsif !player_colliding
      @player_inside = false
    end
  end

  private

  def collider
    @collider ||= game_object.component(Physics::CircleCollider)
  end
end
