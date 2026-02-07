class SoundCaster
  EPSILON = 0.001

  def cast_beams(start:, beam_count:, length:)
    listener_hits = Hash.new { |h, k| h[k] = [] }

    beam_count.times do |i|
      angle = i * Math::PI / (beam_count / 2.0)
      direction = rotate_direction(Vector[0, 1], angle)
      cast_beam(start:, direction:, length:, listener_hits:)
    end

    notify_listeners(listener_hits)
  end

  def cast_beam(start:, direction:, length:, listener_hits: Hash.new { |h, k| h[k] = [] })
    segments = []
    current_pos = start
    current_dir = direction.normalize
    remaining_length = length
    distance_traveled = 0

    while remaining_length > 0
      ray = Physics::Ray.new(start_point: current_pos, direction: current_dir, length: remaining_length)
      hits = Physics.raycast(ray)

      hits.select { |h| has_tag?(h, :listener) }.each do |h|
        sound_hit = SoundHit.new(raycast_hit: h, travel_distance: distance_traveled + h.distance)
        game_object = h.collider.game_object
        listener_hits[game_object] << sound_hit
      end
      wall_hit = hits.select { |h| has_tag?(h, :wall) }.min_by(&:distance)

      if wall_hit && wall_hit.distance < remaining_length && wall_hit.distance > EPSILON
        segments << { from: current_pos, to: wall_hit.point }
        draw_debug_line(current_pos, wall_hit.point)

        distance_traveled += wall_hit.distance
        remaining_length -= wall_hit.distance
        current_dir = reflect(current_dir, wall_hit.normal)
        current_pos = wall_hit.point + current_dir * EPSILON
      else
        end_point = current_pos + current_dir * remaining_length
        segments << { from: current_pos, to: end_point }
        draw_debug_line(current_pos, end_point)
        remaining_length = 0
      end
    end

    { segments: segments, listener_hits: listener_hits }
  end

  def notify_listeners(listener_hits)
    listener_hits.each do |game_object, hits|
      listener = game_object.component(SoundListener)
      listener&.on_sound_hits(self, hits)
    end
  end

  private

  def has_tag?(hit, tag)
    hit.collider.tags.include?(tag)
  end

  def rotate_direction(dir, angle)
    cos_a = Math.cos(angle)
    sin_a = Math.sin(angle)
    Vector[
      dir[0] * cos_a - dir[1] * sin_a,
      dir[0] * sin_a + dir[1] * cos_a
    ]
  end

  def reflect(direction, normal)
    direction - normal * 2 * direction.inner_product(normal)
  end

  def draw_debug_line(from, to)
    Engine::Debug.line(to_3d(from), to_3d(to), color: [1, 1, 1])
  end

  def to_3d(vec2)
    Vector[vec2[0], 0, vec2[1]]
  end
end
