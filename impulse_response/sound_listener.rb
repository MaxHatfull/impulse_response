class SoundListener < Engine::Component
  BOUNCE_LOSS = 1
  SOUND_RANGE = 5

  attr_reader :sound_hits

  def awake
    @sound_hits = {}
  end

  MAX_VOLUME = 1
  BAR_WIDTH = 40
  MAX_BOUNCES = 7

  def update(delta_time)
    puts "======="
    @sound_hits.each do |_source, hits|
      visible_hits = hits.select { |hit| coming_towards_listener?(hit) && has_line_of_sight?(hit) }
      left_hits, right_hits = visible_hits.partition { |hit| hit_from_left?(hit) }

      puts "LEFT:"
      print_volume_by_bounces(left_hits)
      puts "RIGHT:"
      print_volume_by_bounces(right_hits)
    end
  end

  def print_volume_by_bounces(hits)
    grouped = hits.group_by(&:total_bounces)
    (0..MAX_BOUNCES).each do |bounces|
      bounce_hits = grouped[bounces] || []
      vol = bounce_hits.sum { |hit| hit_volume(hit) }
      puts "  #{bounces}: #{volume_bar(vol)}"
    end
  end

  def on_sound_hits(source, hits)
    @sound_hits[source] = hits
  end

  private

  def source_volume(hits)
    hits.select { |hit| has_line_of_sight?(hit) }.sum { |hit| hit_volume(hit) }
  end

  def hit_from_left?(hit)
    listener_pos = Vector[game_object.pos[0], game_object.pos[2]]
    forward = game_object.forward
    forward_2d = Vector[forward[0], forward[2]]
    hit_pos = hit.raycast_hit.entry_point
    to_hit = hit_pos - listener_pos
    # 2D cross product: negative = left, positive = right
    forward_2d[0] * to_hit[1] - forward_2d[1] * to_hit[0] < 0
  end

  def coming_towards_listener?(hit)
    listener_pos = Vector[game_object.pos[0], game_object.pos[2]]
    to_listener = listener_pos - hit.raycast_hit.entry_point
    hit.ray_direction.inner_product(to_listener) > 0
  end

  def has_line_of_sight?(hit)
    listener_pos = Vector[game_object.pos[0], game_object.pos[2]]
    hit_pos = hit.raycast_hit.entry_point
    direction = hit_pos - listener_pos
    distance = direction.magnitude
    return true if distance < 0.001

    ray = Physics::Ray.new(start_point: listener_pos, direction: direction.normalize, length: distance)
    closest_wall = Physics.raycast(ray)
      .select { |h| h.collider.tags.include?(:wall) }
      .min_by(&:entry_distance)
    closest_wall.nil? || closest_wall.entry_distance >= distance - 0.001
  end

  def hit_volume(hit)
    direct = [hit.travel_distance / SOUND_RANGE, 1.0].max
    hit.beam_strength * (1.0 / direct) * (BOUNCE_LOSS ** hit.total_bounces)
  end

  def volume_bar(volume)
    filled = [(volume / MAX_VOLUME * BAR_WIDTH).round, BAR_WIDTH].min
    empty = BAR_WIDTH - filled
    "[#{"█" * filled}#{"░" * empty}] #{volume.round(4)}"
  end
end
