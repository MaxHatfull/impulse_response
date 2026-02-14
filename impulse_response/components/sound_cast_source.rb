class SoundCastSource < Engine::Component
  serialize :beam_length, :beam_count, :volume, :clip, :loop, :play_on_start

  attr_reader :clip, :max_distance

  def start
    @volume ||= 1.0
    @pitch ||= 1.0
    @loop = true if @loop.nil?
    @playing = @play_on_start.nil? ? true : @play_on_start
    @max_distance = @beam_length
    @caster = SoundCaster.new(beam_count: @beam_count, max_distance: @max_distance, beam_strength: beam_strength)
  end

  def pitch
    @pitch
  end

  def loop
    @loop
  end

  def beam_strength
    @volume / @beam_count.to_f
  end

  def update(delta_t)
    return unless @playing

    if !@loop && @play_time
      @play_time += delta_t
      if @play_time >= @clip.duration
        stop
        return
      end
    end

    pos = game_object.world_pos
    hits = @caster.cast_beams(start: Vector[pos[0], pos[2]])
    SoundListener.instance&.on_sound_hits(self, hits)
  end

  def destroy
    SoundListener.instance&.remove_source(self)
  end

  def play
    @playing = true
    @play_time = 0
    SoundListener.instance&.play_source(self)
  end

  def stop
    @playing = false
    @play_time = nil
    SoundListener.instance&.stop_source(self)
  end

  def set_clip(clip)
    @clip = clip
    SoundListener.instance&.clip_changed(self)
  end

  def set_pitch(pitch)
    @pitch = pitch
    SoundListener.instance&.pitch_changed(self)
  end
end
