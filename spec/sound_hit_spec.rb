RSpec.describe SoundHit do
  describe "#initialize" do
    let(:raycast_hit) { instance_double(Physics::RaycastHit) }
    let(:ray_direction) { Vector[1, 0] }
    let(:beam_strength) { 0.5 }

    it "stores the raycast_hit" do
      sound_hit = SoundHit.new(raycast_hit: raycast_hit, travel_distance: 10, total_bounces: 0, ray_direction: ray_direction, beam_strength: beam_strength)

      expect(sound_hit.raycast_hit).to eq(raycast_hit)
    end

    it "stores the travel_distance" do
      sound_hit = SoundHit.new(raycast_hit: raycast_hit, travel_distance: 15.5, total_bounces: 0, ray_direction: ray_direction, beam_strength: beam_strength)

      expect(sound_hit.travel_distance).to eq(15.5)
    end

    it "stores the total_bounces" do
      sound_hit = SoundHit.new(raycast_hit: raycast_hit, travel_distance: 10, total_bounces: 3, ray_direction: ray_direction, beam_strength: beam_strength)

      expect(sound_hit.total_bounces).to eq(3)
    end

    it "stores the ray_direction" do
      sound_hit = SoundHit.new(raycast_hit: raycast_hit, travel_distance: 10, total_bounces: 0, ray_direction: ray_direction, beam_strength: beam_strength)

      expect(sound_hit.ray_direction).to eq(ray_direction)
    end

    it "stores the beam_strength" do
      sound_hit = SoundHit.new(raycast_hit: raycast_hit, travel_distance: 10, total_bounces: 0, ray_direction: ray_direction, beam_strength: beam_strength)

      expect(sound_hit.beam_strength).to eq(0.5)
    end
  end
end
