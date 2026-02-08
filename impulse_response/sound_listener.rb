class SoundListener < Engine::Component
  def awake
    @sound_players = {}
  end

  def on_sound_hits(source, hits)
    @sound_players[source] ||= SoundPlayer.new(source, self)
    @sound_players[source].update(hits)
  end
end
