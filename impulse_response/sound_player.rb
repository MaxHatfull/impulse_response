class SoundPlayer
  BOUNCE_LOSS = 1           # volume multiplier per bounce
  SOUND_RANGE = 5           # distance for full volume
  DISTANCE_BUCKET_SIZE = 2  # meters per bucket

  # debug output
  MAX_VOLUME = 1            # bar max
  BAR_WIDTH = 40            # bar width in chars

  def initialize(source, listener)
    @source = source
    @listener = listener
    @left_volumes = []
    @right_volumes = []
  end

  def update(hits)
    visible_hits = hits.select { |hit| has_line_of_sight?(hit) }
    left_hits, right_hits = visible_hits.partition { |hit| hit_from_left?(hit) }

    @left_volumes = volume_distribution(left_hits)
    @right_volumes = volume_distribution(right_hits)

    print_debug
  end

  private

  def listener_pos
    Vector[@listener.game_object.pos[0], @listener.game_object.pos[2]]
  end

  def forward_2d
    forward = @listener.game_object.forward
    Vector[forward[0], forward[2]]
  end

  def max_distance
    @source.max_distance
  end

  def beam_strength
    @source.beam_strength
  end

  def hit_from_left?(hit)
    to_hit = hit.raycast_hit.entry_point - listener_pos
    # 2D cross product: negative = left, positive = right
    forward_2d[0] * to_hit[1] - forward_2d[1] * to_hit[0] < 0
  end

  def has_line_of_sight?(hit)
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
    beam_strength * (1.0 / direct) * (BOUNCE_LOSS ** hit.total_bounces)
  end

  def num_buckets
    max_distance / DISTANCE_BUCKET_SIZE
  end

  def volume_distribution(hits)
    grouped = hits.group_by { |hit| (hit.travel_distance / DISTANCE_BUCKET_SIZE).floor }
    (0...num_buckets).map do |bucket|
      bucket_hits = grouped[bucket] || []
      bucket_hits.sum { |hit| hit_volume(hit) }
    end
  end

  def print_debug
    puts "LEFT:"
    print_volume_distribution(@left_volumes)
    puts "RIGHT:"
    print_volume_distribution(@right_volumes)
  end

  def print_volume_bar(label, volume)
    filled = [(volume / MAX_VOLUME * BAR_WIDTH).round, BAR_WIDTH].min
    empty = BAR_WIDTH - filled
    puts "  #{label}: [#{"█" * filled}#{"░" * empty}] #{volume.round(4)}"
  end

  def print_volume_distribution(volumes)
    volumes.each_with_index do |vol, bucket|
      label = "#{bucket * DISTANCE_BUCKET_SIZE}-#{(bucket + 1) * DISTANCE_BUCKET_SIZE}m"
      print_volume_bar(label, vol)
    end
  end
end
