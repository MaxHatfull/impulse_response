class SoundCastSource < Engine::Component
  serialize :beam_length

  def update(delta_time)
    SoundCaster.instance.cast_beam(
      start: position_2d,
      direction: forward_2d,
      length: @beam_length
    )
  end

  private

  def position_2d
    pos = game_object.pos
    Vector[pos[0], pos[2]]
  end

  def forward_2d
    forward = game_object.local_to_world_direction(Vector[0, 0, 1])
    Vector[forward[0], forward[2]].normalize
  end
end
