class SoundCaster
  EPSILON = 0.001
  MAX_BOUNCES = 3
  BOUNCE_LOSS = 0.4
  SOUND_RANGE = 10.0

  def initialize(beam_count:, max_distance:, beam_strength:)
    @beam_count = beam_count
    @max_distance = max_distance
    @beam_strength = beam_strength
  end

  def cast_beams(start:)
    @beam_count.times.flat_map do |i|
      angle = i * Math::PI / (@beam_count / 2.0)
      direction = rotate_direction(Vector[0, 1], angle)
      cast_beam(start:, direction:)
    end
  end

  def cast_beam(start:, direction:)
    hits = []
    current_pos = start
    current_dir = direction.normalize
    remaining_length = @max_distance
    distance_traveled = 0
    bounce_count = 0
    current_volume = @beam_strength

    while remaining_length > 0 && bounce_count < MAX_BOUNCES
      ray = Physics::Ray.new(start_point: current_pos, direction: current_dir, length: remaining_length)
      raycast_hits = Physics.raycast(ray)

      wall_hit = raycast_hits.select { |h| has_tag?(h, :wall) }.min_by(&:entry_distance)
      max_distance = wall_hit ? wall_hit.entry_distance : remaining_length

      raycast_hits.select { |h| has_tag?(h, :listener) && h.entry_distance < max_distance && coming_towards?(h, current_dir) }.each do |h|
        total_distance = distance_traveled + h.entry_distance
        volume = volume_at_distance(current_volume, distance_traveled, total_distance)
        hits << SoundHit.new(
          raycast_hit: h,
          travel_distance: total_distance,
          total_bounces: bounce_count,
          volume: volume
        )
      end

      if wall_hit && wall_hit.entry_distance < remaining_length && wall_hit.entry_distance > EPSILON
        draw_debug_line(current_pos, wall_hit.entry_point)

        new_distance = distance_traveled + wall_hit.entry_distance
        current_volume = volume_at_distance(current_volume, distance_traveled, new_distance) * BOUNCE_LOSS
        distance_traveled = new_distance
        remaining_length -= wall_hit.entry_distance
        current_dir = reflect(current_dir, wall_hit.entry_normal)
        current_pos = wall_hit.entry_point + current_dir * EPSILON
        bounce_count += 1
      else
        end_point = current_pos + current_dir * remaining_length
        draw_debug_line(current_pos, end_point)
        remaining_length = 0
      end
    end

    hits
  end

  private

  def volume_at_distance(current_volume, start_distance, end_distance)
    # Inverse distance falloff, with full volume up to SOUND_RANGE
    start_factor = [start_distance / SOUND_RANGE, 1.0].max
    end_factor = [end_distance / SOUND_RANGE, 1.0].max
    current_volume * (start_factor / end_factor)
  end

  private

  def has_tag?(hit, tag)
    hit.collider.tags.include?(tag)
  end

  def coming_towards?(hit, ray_dir)
    listener_pos = hit.collider.center
    to_listener = listener_pos - hit.entry_point
    ray_dir.inner_product(to_listener) > 0
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
    #Engine::Debug.line(to_3d(from), to_3d(to), color: [1, 1, 1])
  end

  def to_3d(vec2)
    Vector[vec2[0], 0, vec2[1]]
  end
end
