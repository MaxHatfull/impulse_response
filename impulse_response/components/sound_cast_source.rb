class SoundCastSource < Engine::Component
  serialize :beam_length, :beam_count, :volume

  def start
    @caster = SoundCaster.new
  end

  def update(delta_t)
    pos = game_object.pos
    @caster.cast_beams(
      start: Vector[pos[0], pos[2]],
      beam_count: @beam_count,
      length: @beam_length,
      volume: @volume || 1.0
    )
  end
end
