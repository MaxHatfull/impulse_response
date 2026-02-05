require 'singleton'

class SoundCaster
  include Singleton

  def cast_beam(start:, direction:, length:)
    segments = []
    current_pos = start
    current_dir = direction.normalize
    remaining_length = length

    while remaining_length > 0
      ray = Physics::Ray.new(start_point: current_pos, direction: current_dir, length: remaining_length)
      hit = Physics.closest_raycast(ray)

      if hit && hit.distance < remaining_length
        segments << { from: current_pos, to: hit.point }
        draw_debug_line(current_pos, hit.point)

        remaining_length -= hit.distance
        current_pos = hit.point
        current_dir = reflect(current_dir, hit.normal)
      else
        end_point = current_pos + current_dir * remaining_length
        segments << { from: current_pos, to: end_point }
        draw_debug_line(current_pos, end_point)
        remaining_length = 0
      end
    end

    segments
  end

  private

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
