class Interacter < Engine::Component
  serialize :on_interact

  @enabled = true

  class << self
    def disable_all
      @enabled = false
    end

    def enable_all
      @enabled = true
    end

    def enabled?
      @enabled
    end
  end

  def update(delta_time)
    return unless Interacter.enabled?
    return unless Engine::Input.key_down?(Engine::Input::KEY_E)
    return unless player_colliding?

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
