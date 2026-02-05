class SoundCastSource < Engine::Component
  serialize :beam_length, :beam_color

  def update(delta_time)
    8.times do |i|
      angle = i * Math::PI / 4
      direction = rotate_direction(forward_2d, angle)
      SoundCaster.instance.cast_beam(
        start: position_2d,
        direction: direction,
        length: @beam_length,
        color: @beam_color
      )
    end
  end

  private

  def position_2d
    pos = game_object.pos
    Vector[pos[0], pos[2]]
  end

  def forward_2d
    forward = game_object.local_to_world_direction(Vector[0, 0, 1])
    Vector[forward[0], forward[2]].normalize
  end

  def rotate_direction(dir, angle)
    cos_a = Math.cos(angle)
    sin_a = Math.sin(angle)
    Vector[
      dir[0] * cos_a - dir[1] * sin_a,
      dir[0] * sin_a + dir[1] * cos_a
    ]
  end
end
