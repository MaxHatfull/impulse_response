class SoundCaster
  EPSILON = 0.001
  MAX_BOUNCES = 3
  BOUNCE_LOSS = 0.4
  NEAR_FIELD = 5.0
  ROLLOFF = 1.0

  def initialize(beam_count:, max_distance:, beam_strength:)
    @beam_count = beam_count
    @max_distance = max_distance
    @beam_strength = beam_strength
  end

  def cast_beams(start:, start_angle: 0, end_angle: 2 * Math::PI)
    arc_range = end_angle - start_angle
    @beam_count.times.flat_map do |i|
      angle = start_angle + (i * arc_range / @beam_count)
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

      listener_hit = raycast_hits
        .select { |h| has_tag?(h, :listener) && h.entry_distance < max_distance && coming_towards?(h, current_dir) && has_line_of_sight?(h) }
        .min_by(&:entry_distance)

      if listener_hit
        total_distance = distance_traveled + listener_hit.entry_distance
        volume = volume_at_distance(current_volume, distance_traveled, total_distance)
        hits << SoundHit.new(
          raycast_hit: listener_hit,
          travel_distance: total_distance,
          total_bounces: bounce_count,
          volume: volume
        )
        break
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
    # Inverse distance falloff, with full volume within NEAR_FIELD
    start_factor = [start_distance / NEAR_FIELD, 1.0].max
    end_factor = [end_distance / NEAR_FIELD, 1.0].max
    current_volume * ((start_factor / end_factor) ** ROLLOFF)
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

  def has_line_of_sight?(hit)
    hit_pos = hit.entry_point
    direction = hit_pos - listener_pos_2d
    distance = direction.magnitude
    return true if distance < 0.001

    ray = Physics::Ray.new(start_point: listener_pos_2d, direction: direction.normalize, length: distance)
    closest_wall = Physics.raycast(ray)
                          .select { |h| h.collider.tags.include?(:wall) }
                          .min_by(&:entry_distance)
    closest_wall.nil? || closest_wall.entry_distance >= distance - 0.001
  end

  def listener_pos_2d
    pos = SoundListener.instance.game_object.pos
    Vector[pos[0], pos[2]]
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
