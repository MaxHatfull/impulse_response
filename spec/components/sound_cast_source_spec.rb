require "spec_helper"
require_relative "../../impulse_response/loader"

RSpec.describe SoundCastSource do
  before { Physics.clear_colliders }

  describe "#update" do
    it "casts 8 beams from the game object position" do
      source = SoundCastSource.create(beam_length: 20, beam_color: [1, 0, 0])
      Engine::GameObject.create(
        pos: Vector[5, 0, 10],
        components: [source]
      )

      expect(SoundCaster.instance).to receive(:cast_beam)
        .with(hash_including(start: Vector[5, 10], length: 20, color: [1, 0, 0]))
        .exactly(8).times

      source.update(0.016)
    end

    it "casts beams in 8 evenly spaced directions" do
      source = SoundCastSource.create(beam_length: 20, beam_color: [1, 1, 1])
      Engine::GameObject.create(
        pos: Vector[0, 0, 0],
        components: [source]
      )

      directions = []
      allow(SoundCaster.instance).to receive(:cast_beam) do |args|
        directions << args[:direction]
      end

      source.update(0.016)

      # Check we got 8 directions
      expect(directions.length).to eq(8)

      # Check they're evenly spaced (45 degrees apart)
      angles = directions.map { |d| Math.atan2(d[1], d[0]) }
      angles.sort!

      angle_diffs = angles.each_cons(2).map { |a, b| b - a }
      angle_diffs.each do |diff|
        expect(diff).to be_within(0.01).of(Math::PI / 4)
      end
    end

    it "rotates all beams with game object rotation" do
      source = SoundCastSource.create(beam_length: 20, beam_color: [1, 1, 1])
      Engine::GameObject.create(
        pos: Vector[0, 0, 0],
        rotation: Engine::Quaternion.from_euler(Vector[0, 90, 0]),
        components: [source]
      )

      directions = []
      allow(SoundCaster.instance).to receive(:cast_beam) do |args|
        directions << args[:direction]
      end

      source.update(0.016)

      # First beam should be in -X direction (rotated 90 degrees from +Z)
      expect(directions[0][0]).to be_within(0.01).of(-1)
      expect(directions[0][1]).to be_within(0.01).of(0)
    end
  end
end
