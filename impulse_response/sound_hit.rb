class SoundHit
  attr_reader :raycast_hit, :travel_distance, :total_bounces, :ray_direction

  def initialize(raycast_hit:, travel_distance:, total_bounces:, ray_direction:)
    @raycast_hit = raycast_hit
    @travel_distance = travel_distance
    @total_bounces = total_bounces
    @ray_direction = ray_direction
  end
end
