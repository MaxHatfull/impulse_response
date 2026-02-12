class Interacter < Engine::Component
  serialize :on_interact, :enter_clip

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

  def start
    @player_inside = false
    @enter_clip ||= Sounds.interacter_enter
  end

  def update(delta_time)
    return unless Interacter.enabled?

    player_colliding = player_colliding?

    if player_colliding && !@player_inside
      @player_inside = true
      play_enter_clip
    elsif !player_colliding
      @player_inside = false
    end

    return unless Engine::Input.key_down?(Engine::Input::KEY_E)
    return unless player_colliding

    @on_interact&.call
  end

  private

  def play_enter_clip
    return unless @enter_clip

    audio_source = NativeAudio::AudioSource.new(@enter_clip)
    audio_source.set_looping(false)
    audio_source.play
  end

  def player_colliding?
    Physics.collisions(collider, tag: :player).any?
  end

  def collider
    @collider ||= game_object.component(Physics::CircleCollider)
  end
end
