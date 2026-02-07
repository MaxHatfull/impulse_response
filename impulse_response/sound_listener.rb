class SoundListener < Engine::Component
  attr_reader :sound_hits

  MAX_HITS = 15

  def awake
    @sound_hits = {}
  end

  def update(delta_time)
    hit_count = @sound_hits.values.flatten.length
    t = [hit_count.to_f / MAX_HITS, 1.0].min
    color = [1.0 - t, t, 0]
    Engine::Debug.sphere(game_object.pos, 0.25, color: color)
  end

  def on_sound_hits(source, hits)
    @sound_hits[source] = hits
  end
end
