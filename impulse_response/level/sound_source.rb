class Level
  class SoundSource
    def self.create(parent:, x:, z:, clip: nil, beam_length: 40, beam_count: 64, volume: 10, loop: true, play_on_start: true, start_angle: 0, end_angle: 2 * Math::PI)
      pos = Vector[x, 0, z]
      game_object = Engine::GameObject.create(
        pos: pos,
        components: [
          SoundCastSource.create(
            beam_length: beam_length, beam_count: beam_count, volume: volume,
            clip: clip, loop: loop, play_on_start: play_on_start,
            start_angle: start_angle, end_angle: end_angle
          )
        ]
      )
      game_object.parent = parent
      if DEBUG
        Engine::StandardObjects::Sphere.create(pos: pos, parent: parent, scale: Vector[0.5, 0.5, 0.5])
      end
      game_object
    end
  end
end
