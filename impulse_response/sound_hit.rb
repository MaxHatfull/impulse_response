class SoundHit
  attr_reader :raycast_hit, :travel_distance, :total_bounces, :ray_direction, :beam_strength

  def initialize(raycast_hit:, travel_distance:, total_bounces:, ray_direction:, beam_strength:)
    @raycast_hit = raycast_hit
    @travel_distance = travel_distance
    @total_bounces = total_bounces
    @ray_direction = ray_direction
    @beam_strength = beam_strength
  end
end
