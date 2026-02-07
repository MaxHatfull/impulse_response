class SoundListener < Engine::Component
  attr_reader :sound_hits

  MAX_HITS = 10

  def awake
    @sound_hits = {}
  end

  def update(delta_time)
    hit_count = @sound_hits.values.flatten.length
    puts game_object.name if hit_count > 0
    puts hit_count if hit_count > 0
    t = [hit_count.to_f / MAX_HITS, 1.0].min
    puts t if hit_count > 0
    color = [1.0 - t, t, 0]
    return unless hit_count > 0
    Engine::Debug.sphere(game_object.pos, 0.5, color: color)
  end

  def on_sound_hits(source, hits)
    @sound_hits[source] = hits
  end
end
