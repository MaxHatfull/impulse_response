RSpec.describe SoundHit do
  describe "#initialize" do
    it "stores the raycast_hit" do
      raycast_hit = instance_double(Physics::RaycastHit)
      sound_hit = SoundHit.new(raycast_hit: raycast_hit, travel_distance: 10)

      expect(sound_hit.raycast_hit).to eq(raycast_hit)
    end

    it "stores the travel_distance" do
      raycast_hit = instance_double(Physics::RaycastHit)
      sound_hit = SoundHit.new(raycast_hit: raycast_hit, travel_distance: 15.5)

      expect(sound_hit.travel_distance).to eq(15.5)
    end
  end
end
