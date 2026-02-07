class SoundListener < Engine::Component
  attr_reader :sound_hits

  def awake
    @sound_hits = {}
  end

  def on_sound_hits(source, hits)
    if !@sound_hits.key?(source)
      source.on_reset do
        @sound_hits[source] = []
      end
    end
    @sound_hits[source] = hits
  end
end
