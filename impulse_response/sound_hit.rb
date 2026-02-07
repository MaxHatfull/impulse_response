class SoundHit
  attr_reader :raycast_hit, :travel_distance

  def initialize(raycast_hit:, travel_distance:)
    @raycast_hit = raycast_hit
    @travel_distance = travel_distance
  end
end
