class SoundCastSource < Engine::Component
  serialize :beam_length, :beam_count, :volume, :clip_path, :loop, :play_on_start

  def start
    clip = NativeAudio::Clip.new(@clip_path || "impulse_response/assets/audio/test.wav")
    @caster = SoundCaster.new(
      beam_count: @beam_count,
      length: @beam_length,
      volume: @volume || 1.0,
      clip: clip,
      loop: @loop.nil? ? true : @loop,
      play_on_start: @play_on_start.nil? ? true : @play_on_start
    )
  end

  def update(delta_t)
    pos = game_object.pos
    @caster.cast_beams(start: Vector[pos[0], pos[2]])
  end

  def destroy
    @caster.destroy
  end

  def play
    @caster.play
  end

  def stop
    @caster.stop
  end
end
