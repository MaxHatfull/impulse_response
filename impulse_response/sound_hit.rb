class SoundHit
  attr_reader :raycast_hit, :travel_distance, :total_bounces

  def initialize(raycast_hit:, travel_distance:, total_bounces:)
    @raycast_hit = raycast_hit
    @travel_distance = travel_distance
    @total_bounces = total_bounces
  end

  def ray_direction
    raycast_hit.ray.direction
  end
end
