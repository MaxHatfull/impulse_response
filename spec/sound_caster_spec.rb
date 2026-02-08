RSpec.describe SoundCaster do
  describe "#cast_beam" do
    let(:sound_caster) { SoundCaster.new(beam_count: 8, length: 10, volume: 1.0, clip: nil) }

    context "when a listener is hit" do
      it "records the listener hit" do
        create_circle(center: Vector[5, 0], radius: 1, tags: [:listener])
        start = Vector[0, 0]
        direction = Vector[1, 0]

        result = sound_caster.cast_beam(start:, direction:)
        all_hits = result.values.flatten

        expect(result.keys.length).to eq(1)
        expect(all_hits.first).to be_a(SoundHit)
      end

      it "includes travel_distance in SoundHit" do
        create_circle(center: Vector[5, 0], radius: 1, tags: [:listener])
        start = Vector[0, 0]
        direction = Vector[1, 0]

        result = sound_caster.cast_beam(start:, direction:)
        all_hits = result.values.flatten

        expect(all_hits.first.travel_distance).to be_within(0.01).of(4)
      end

      it "includes the raycast_hit in SoundHit" do
        create_circle(center: Vector[5, 0], radius: 1, tags: [:listener])
        start = Vector[0, 0]
        direction = Vector[1, 0]

        result = sound_caster.cast_beam(start:, direction:)
        all_hits = result.values.flatten

        expect(all_hits.first.raycast_hit).to be_a(Physics::RaycastHit)
        expect(all_hits.first.raycast_hit.entry_point[0]).to be_within(0.01).of(4)
      end
    end

    context "with listener behind wall" do
      let(:caster) { SoundCaster.new(beam_count: 8, length: 15, volume: 1.0, clip: nil) }

      it "does not register hit on listener behind wall" do
        create_circle(center: Vector[5, 0], radius: 1, tags: [:wall])
        create_circle(center: Vector[10, 0], radius: 1, tags: [:listener])
        start = Vector[0, 0]
        direction = Vector[1, 0]

        result = caster.cast_beam(start:, direction:)

        expect(result.keys.length).to eq(0)
      end

      it "registers hit on listener in front of wall" do
        create_circle(center: Vector[3, 0], radius: 1, tags: [:listener])
        create_circle(center: Vector[10, 0], radius: 1, tags: [:wall])
        start = Vector[0, 0]
        direction = Vector[1, 0]

        result = caster.cast_beam(start:, direction:)

        expect(result.keys.length).to eq(1)
      end
    end

    context "with listener after wall bounce" do
      it "accumulates travel_distance through bounces" do
        caster = SoundCaster.new(beam_count: 8, length: 20, volume: 1.0, clip: nil)
        create_circle(center: Vector[5, 0], radius: 1, tags: [:wall])
        create_circle(center: Vector[-5, 0], radius: 1, tags: [:listener])
        start = Vector[0, 0]
        direction = Vector[1, 0]

        result = caster.cast_beam(start:, direction:)
        all_hits = result.values.flatten

        expect(result.keys.length).to eq(1)
        # 4 units to wall + 8 units back to listener = 12 total
        expect(all_hits.first.travel_distance).to be_within(0.1).of(12)
      end
    end
  end

  describe "#cast_beams" do
    let(:sound_caster) { SoundCaster.new(beam_count: 8, length: 10, volume: 1.0, clip: nil) }

    it "casts the specified number of beams" do
      start = Vector[0, 0]

      expect(sound_caster).to receive(:cast_beam).exactly(8).times.and_call_original

      sound_caster.cast_beams(start:)
    end

    it "casts beams in evenly spaced directions" do
      start = Vector[0, 0]

      directions = []
      allow(sound_caster).to receive(:cast_beam) do |args|
        directions << args[:direction]
        {}
      end

      sound_caster.cast_beams(start:)

      expect(directions.length).to eq(8)

      angles = directions.map { |d| Math.atan2(d[1], d[0]) }
      angles.sort!

      angle_diffs = angles.each_cons(2).map { |a, b| b - a }
      angle_diffs.each do |diff|
        expect(diff).to be_within(0.01).of(Math::PI / 4)
      end
    end

  end
end
