class SoundPlayer
  BOUNCE_LOSS = 0.4 # volume multiplier per bounce
  SOUND_RANGE = 10 # distance for full volume
  DISTANCE_BUCKET_SIZE = 5 # meters per bucket

  # audio
  LEFT_ANGLE = 270
  RIGHT_ANGLE = 90

  # debug output
  MAX_VOLUME = 1 # bar max
  BAR_WIDTH = 40 # bar width in chars

  def initialize(source, listener)
    @source = source
    @listener = listener
    @left_contributions = []
    @right_contributions = []
    @left_audio = NativeAudio::AudioSource.new(@source.clip)
    @right_audio = NativeAudio::AudioSource.new(@source.clip)
    play
  end

  def update(hits)
    visible_hits = hits.select { |hit| has_line_of_sight?(hit) }
    build_stereo_contributions(visible_hits)

    update_audio
    # print_debug
  end

  def stop
    @left_audio.stop
    @right_audio.stop
  end

  def play
    @left_audio.play
    @left_audio.set_volume(0)
    @right_audio.play
    @right_audio.set_volume(0)

    @left_audio.set_pos(LEFT_ANGLE, 10)
    @left_audio.set_looping(@source.loop)

    @right_audio.set_pos(RIGHT_ANGLE, 10)
    @right_audio.set_looping(@source.loop)
  end

  def clip_changed
    @left_audio.stop
    @right_audio.stop

    @left_audio = NativeAudio::AudioSource.new(@source.clip)
    @right_audio = NativeAudio::AudioSource.new(@source.clip)

    play
  end

  def build_stereo_contributions(hits)
    @left_contributions = []
    @right_contributions = []

    hits.each do |hit|
      volume = hit_volume(hit)
      bounces = hit.total_bounces
      left_pan, right_pan = stereo_pan(hit)

      @left_contributions << { volume: volume * left_pan, bounces: bounces }
      @right_contributions << { volume: volume * right_pan, bounces: bounces }
    end
  end

  def stereo_pan(hit)
    to_hit = hit.raycast_hit.entry_point - listener_pos
    angle = Math.atan2(to_hit[1], to_hit[0]) - Math.atan2(forward_2d[1], forward_2d[0])

    # right_pan: 0° (forward) = 0.5, 90° (right) = 1.0, 180° = 0.5, 270° (left) = 0.0
    right_pan = 0.5 + 0.5 * Math.sin(angle)
    left_pan = 1.0 - right_pan

    [left_pan, right_pan]
  end

  private

  def update_audio
    left_total = @left_contributions.sum { |c| c[:volume] }
    right_total = @right_contributions.sum { |c| c[:volume] }

    @left_audio.set_volume((left_total * 128).clamp(0, 128).to_i)
    @right_audio.set_volume((right_total * 128).clamp(0, 128).to_i)

    left_reverb = reverb_from_contributions(@left_contributions)
    right_reverb = reverb_from_contributions(@right_contributions)

    @left_audio.set_reverb(**left_reverb)
    @right_audio.set_reverb(**right_reverb)
  end

  def reverb_from_contributions(contributions)
    return { room_size: 0.0, damping: 0.5, wet: 0.0, dry: 0.0 } if contributions.empty?

    grouped = contributions.group_by { |c| c[:bounces] }

    total_volume = 0.0
    weighted_dry = 0.0
    weighted_wet = 0.0
    weighted_bounces = 0.0

    grouped.each do |bounce_count, group|
      group_volume = group.sum { |c| c[:volume] }
      total_volume += group_volume

      dry_weight = 1.0 / (bounce_count + 1)
      wet_weight = bounce_count.to_f / (bounce_count + 1)

      weighted_dry += group_volume * dry_weight
      weighted_wet += group_volume * wet_weight
      weighted_bounces += group_volume * bounce_count
    end

    return { room_size: 0.0, damping: 0.5, wet: 0.0, dry: 0.0 } if total_volume <= 0

    avg_bounces = weighted_bounces / total_volume
    room_size = (Math.sqrt(avg_bounces) / 20.0).clamp(0.0, 1.0)
    dry = (weighted_dry / total_volume).clamp(0.0, 1.0)
    wet = (weighted_wet / total_volume).clamp(0.0, 1.0)

    { room_size: room_size, damping: 0.3, wet: wet, dry: dry }
  end

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
    print_volume_by_bounces(@left_contributions)
    puts "RIGHT:"
    print_volume_by_bounces(@right_contributions)
  end

  def print_volume_by_bounces(contributions)
    grouped = contributions.group_by { |c| c[:bounces] }
    (0..10).each do |bounce_count|
      group = grouped[bounce_count] || []
      vol = group.sum { |c| c[:volume] }
      print_volume_bar("#{bounce_count} bounces", vol)
    end
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
