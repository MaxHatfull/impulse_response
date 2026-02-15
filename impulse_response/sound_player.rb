class SoundPlayer
  BOUNCE_LOSS = 0.4 # volume multiplier per bounce
  SOUND_RANGE = 10 # distance for full volume
  REVERB_RANGE = 15 # distance for full wet reverb
  DISTANCE_BUCKET_SIZE = 5 # meters per bucket
  MIN_ECHO_DISTANCE = 10.0 # bounces shorter than this blend with direct sound

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
    build_stereo_contributions(hits)

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
    @left_audio.set_pitch(@source.pitch)

    @right_audio.set_pos(RIGHT_ANGLE, 10)
    @right_audio.set_looping(@source.loop)
    @right_audio.set_pitch(@source.pitch)
  end

  def clip_changed
    @left_audio.stop
    @right_audio.stop

    @left_audio = NativeAudio::AudioSource.new(@source.clip)
    @right_audio = NativeAudio::AudioSource.new(@source.clip)

    play
  end

  def set_pitch(pitch)
    @left_audio.set_pitch(pitch)
    @right_audio.set_pitch(pitch)
  end

  def build_stereo_contributions(hits)
    @left_contributions = []
    @right_contributions = []

    hits.each do |hit|
      volume = hit.volume
      bounces = hit.total_bounces
      distance = hit.travel_distance
      left_pan, right_pan = stereo_pan(hit)

      @left_contributions << { volume: volume * left_pan, bounces: bounces, distance: distance }
      @right_contributions << { volume: volume * right_pan, bounces: bounces, distance: distance }
    end
  end

  def stereo_pan(hit)
    # Use incoming ray direction (negated = direction sound came FROM)
    # Alternative: use entry_point position relative to listener, but this
    # gives wrong panning for glancing hits (e.g. sound from right grazing left ear)
    from_dir = -hit.ray_direction
    angle = Math.atan2(from_dir[1], from_dir[0]) - Math.atan2(forward_2d[1], forward_2d[0])

    # right_pan: 0° (forward) = 0.5, 90° (right) = 1.0, 180° = 0.5, 270° (left) = 0.0
    right_pan = 0.5 + 0.5 * Math.sin(angle)
    left_pan = 1.0 - right_pan

    [left_pan, right_pan]
  end

  private

  def update_audio
    left_total = @left_contributions.sum { |c| c[:volume] }
    right_total = @right_contributions.sum { |c| c[:volume] }

    puts "left too loud" if left_total > 128
    puts "right too loud" if right_total > 128

    @left_audio.set_volume((left_total * 128).clamp(0, 128).to_i)
    @right_audio.set_volume((right_total * 128).clamp(0, 128).to_i)

    left_reverb = reverb_from_contributions(@left_contributions)
    right_reverb = reverb_from_contributions(@right_contributions)

    @left_audio.set_reverb(**left_reverb)
    @right_audio.set_reverb(**right_reverb)
  end

  def reverb_from_contributions(contributions)
    return { room_size: 0.0, damping: 0.0, wet: 0.0, dry: 1.0 } if contributions.empty?

    total_volume = contributions.sum { |c| c[:volume] }
    return { room_size: 0.0, damping: 0.0, wet: 0.0, dry: 1.0 } if total_volume <= 0

    # Direct hits (0 bounces) are dry, bounced hits are wet
    # Short bounces blend with direct sound - wetness scales with distance
    bounced_volume = contributions.select { |c| c[:bounces] > 0 }.sum { |c| c[:volume] * c[:distance] / MIN_ECHO_DISTANCE }

    wet = [bounced_volume / total_volume, 1.0].min
    dry = 1.0 - wet

    # Average bounces weighted by volume - more bounces = duller sound
    avg_bounces = contributions.sum { |c| c[:volume] * c[:bounces] } / total_volume
    damping = (avg_bounces / SoundCaster::MAX_BOUNCES) * 0.5

    # Room size based on distance of bounced sounds only
    bounced = contributions.select { |c| c[:bounces] > 0 }
    if bounced.empty?
      room_size = 0.0
    else
      bounced_total = bounced.sum { |c| c[:volume] }
      avg_bounced_distance = bounced.sum { |c| c[:volume] * c[:distance] } / bounced_total
      room_size = (avg_bounced_distance / max_distance).clamp(0.0, 1.0)
    end

    {
      room_size: room_size,
      damping: damping * 0.01,
      wet: wet * 0.4,
      dry: dry
    }
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
