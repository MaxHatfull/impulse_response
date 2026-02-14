RSpec.describe SoundHit do
  describe "#initialize" do
    let(:ray) { instance_double(Physics::Ray, direction: Vector[1, 0]) }
    let(:raycast_hit) { instance_double(Physics::RaycastHit, ray: ray) }

    it "stores the raycast_hit" do
      sound_hit = SoundHit.new(raycast_hit: raycast_hit, travel_distance: 10, total_bounces: 0, volume: 1.0)

      expect(sound_hit.raycast_hit).to eq(raycast_hit)
    end

    it "stores the travel_distance" do
      sound_hit = SoundHit.new(raycast_hit: raycast_hit, travel_distance: 15.5, total_bounces: 0, volume: 1.0)

      expect(sound_hit.travel_distance).to eq(15.5)
    end

    it "stores the total_bounces" do
      sound_hit = SoundHit.new(raycast_hit: raycast_hit, travel_distance: 10, total_bounces: 3, volume: 1.0)

      expect(sound_hit.total_bounces).to eq(3)
    end

    it "stores the volume" do
      sound_hit = SoundHit.new(raycast_hit: raycast_hit, travel_distance: 10, total_bounces: 0, volume: 0.75)

      expect(sound_hit.volume).to eq(0.75)
    end

    it "gets ray_direction from the raycast_hit" do
      sound_hit = SoundHit.new(raycast_hit: raycast_hit, travel_distance: 10, total_bounces: 0, volume: 1.0)

      expect(sound_hit.ray_direction).to eq(Vector[1, 0])
    end
  end
end
