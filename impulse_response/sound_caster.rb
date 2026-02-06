require 'singleton'

class SoundCaster
  include Singleton

  EPSILON = 0.001

  def cast_beam(start:, direction:, length:, color: [1, 1, 1])
    segments = []
    current_pos = start
    current_dir = direction.normalize
    remaining_length = length

    while remaining_length > 0
      ray = Physics::Ray.new(start_point: current_pos, direction: current_dir, length: remaining_length)
      hit = Physics.closest_raycast(ray, tag: :wall)

      if hit && hit.distance < remaining_length && hit.distance > EPSILON
        segments << { from: current_pos, to: hit.point }
        draw_debug_line(current_pos, hit.point, color)

        remaining_length -= hit.distance
        current_dir = reflect(current_dir, hit.normal)
        current_pos = hit.point + current_dir * EPSILON
      else
        end_point = current_pos + current_dir * remaining_length
        segments << { from: current_pos, to: end_point }
        draw_debug_line(current_pos, end_point, color)
        remaining_length = 0
      end
    end

    segments
  end

  private

  def reflect(direction, normal)
    direction - normal * 2 * direction.inner_product(normal)
  end

  def draw_debug_line(from, to, color)
    Engine::Debug.line(to_3d(from), to_3d(to), color: color)
  end

  def to_3d(vec2)
    Vector[vec2[0], 0, vec2[1]]
  end
end
