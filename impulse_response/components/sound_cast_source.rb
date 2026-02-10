class SoundCastSource < Engine::Component
  serialize :beam_length, :beam_count, :volume, :clip_path

  def start
    clip = NativeAudio::Clip.new(@clip_path || "impulse_response/assets/audio/test.wav")
    @caster = SoundCaster.new(
      beam_count: @beam_count,
      length: @beam_length,
      volume: @volume || 1.0,
      clip: clip
    )
  end

  def update(delta_t)
    pos = game_object.pos
    @caster.cast_beams(start: Vector[pos[0], pos[2]])
  end

  def destroy
    @caster.destroy
  end
end
