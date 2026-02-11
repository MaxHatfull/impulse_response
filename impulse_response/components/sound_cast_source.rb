class SoundCastSource < Engine::Component
  serialize :beam_length, :beam_count, :volume, :clip_path, :loop, :play_on_start

  attr_reader :clip, :max_distance

  def start
    @clip = NativeAudio::Clip.new(@clip_path || "impulse_response/assets/audio/basic_audio/test.wav")
    @volume ||= 1.0
    @loop = true if @loop.nil?
    @playing = @play_on_start.nil? ? true : @play_on_start
    @max_distance = @beam_length
    @caster = SoundCaster.new(beam_count: @beam_count, max_distance: @max_distance)
  end

  def loop
    @loop
  end

  def beam_strength
    @volume / @beam_count.to_f
  end

  def update(delta_t)
    return unless @playing

    pos = game_object.pos
    hits = @caster.cast_beams(start: Vector[pos[0], pos[2]])
    SoundListener.instance&.on_sound_hits(self, hits)
  end

  def destroy
    SoundListener.instance&.remove_source(self)
  end

  def play
    @playing = true
    SoundListener.instance&.play_source(self)
  end

  def stop
    @playing = false
    SoundListener.instance&.stop_source(self)
  end

  def set_clip(clip)
    @clip = clip
    SoundListener.instance&.clip_changed(self)
  end
end
