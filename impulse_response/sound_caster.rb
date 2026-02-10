class SoundCaster
  EPSILON = 0.001

  attr_reader :max_distance, :beam_strength, :clip, :loop, :play_on_start

  def initialize(beam_count:, length:, volume: 1.0, clip:, loop: true, play_on_start: true)
    @beam_count = beam_count
    @max_distance = length
    @beam_strength = volume / beam_count.to_f
    @clip = clip
    @loop = loop
    @play_on_start = play_on_start
    @playing = play_on_start
    @known_listeners = Set.new
  end

  def cast_beams(start:)
    return unless @playing

    all_hits = Hash.new { |h, k| h[k] = [] }

    @beam_count.times do |i|
      angle = i * Math::PI / (@beam_count / 2.0)
      direction = rotate_direction(Vector[0, 1], angle)
      cast_beam(start:, direction:).each do |game_object, hits|
        all_hits[game_object].concat(hits)
      end
    end

    notify_listeners(all_hits)
  end

  def cast_beam(start:, direction:)
    listener_hits = Hash.new { |h, k| h[k] = [] }
    current_pos = start
    current_dir = direction.normalize
    remaining_length = @max_distance
    distance_traveled = 0
    bounce_count = 0

    while remaining_length > 0
      ray = Physics::Ray.new(start_point: current_pos, direction: current_dir, length: remaining_length)
      hits = Physics.raycast(ray)

      wall_hit = hits.select { |h| has_tag?(h, :wall) }.min_by(&:entry_distance)
      max_distance = wall_hit ? wall_hit.entry_distance : remaining_length

      hits.select { |h| has_tag?(h, :listener) && h.entry_distance < max_distance && coming_towards?(h, current_dir) }.each do |h|
        sound_hit = SoundHit.new(
          raycast_hit: h,
          travel_distance: distance_traveled + h.entry_distance,
          total_bounces: bounce_count
        )
        game_object = h.collider.game_object
        listener_hits[game_object] << sound_hit
      end

      if wall_hit && wall_hit.entry_distance < remaining_length && wall_hit.entry_distance > EPSILON
        draw_debug_line(current_pos, wall_hit.entry_point)

        distance_traveled += wall_hit.entry_distance
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

    listener_hits
  end

  def destroy
    @known_listeners.each { |listener| listener.remove_source(self) }
  end

  def play
    @playing = true
    @known_listeners.each { |listener| listener.play_source(self) }
  end

  def stop
    @playing = false
    @known_listeners.each { |listener| listener.stop_source(self) }
  end

  def set_clip(clip)
    @clip = clip
    @known_listeners.each { |listener| listener.set_clip(self, clip) }
  end

  private

  def notify_listeners(listener_hits)
    current_listeners = Set.new

    listener_hits.each do |game_object, hits|
      listener = game_object.component(SoundListener)
      next unless listener

      current_listeners.add(listener)
      listener.on_sound_hits(self, hits)
    end

    # Remove sources for listeners no longer in range
    (@known_listeners - current_listeners).each do |listener|
      listener.remove_source(self)
    end

    @known_listeners = current_listeners
  end

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
