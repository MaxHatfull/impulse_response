class SoundListener < Engine::Component
  def awake
    @sound_players = {}
  end

  def on_sound_hits(source, hits)
    @sound_players[source] ||= SoundPlayer.new(source, self)
    @sound_players[source].update(hits)
  end

  def remove_source(source)
    player = @sound_players.delete(source)
    player&.stop
  end

  def play_source(source)
    @sound_players[source]&.play
  end

  def stop_source(source)
    @sound_players[source]&.stop
  end
end
