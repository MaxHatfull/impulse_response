class SoundCastSource < Engine::Component
  serialize :beam_length, :beam_count, :volume

  def start
    @caster = SoundCaster.new(
      beam_count: @beam_count,
      length: @beam_length,
      volume: @volume || 1.0
    )
  end

  def update(delta_t)
    pos = game_object.pos
    @caster.cast_beams(start: Vector[pos[0], pos[2]])
  end
end
