class Level
  class SoundSource
    def self.create(parent:, x:, z:, clip: nil, beam_length: 40, beam_count: 64, volume: 10, loop: true, play_on_start: true)
      pos = Vector[x, 0, z]
      game_object = Engine::GameObject.create(
        pos: pos,
        components: [
          SoundCastSource.create(
            beam_length: beam_length, beam_count: beam_count, volume: volume,
            clip: clip, loop: loop, play_on_start: play_on_start
          )
        ]
      )
      game_object.parent = parent
      Engine::StandardObjects::Sphere.create(pos: pos, parent: parent, scale: Vector[0.5, 0.5, 0.5])
      game_object
    end
  end
end
