RSpec.describe SoundCaster do
  describe "#cast_beam" do
    let(:sound_caster) { SoundCaster.new }

    context "when no colliders are hit" do
      it "returns a single segment from start to end of length" do
        start = Vector[0, 0]
        direction = Vector[1, 0]
        length = 10

        result = sound_caster.cast_beam(start:, direction:, length:)

        expect(result[:segments].length).to eq(1)
        expect(result[:segments][0][:from]).to eq(Vector[0, 0])
        expect(result[:segments][0][:to]).to eq(Vector[10, 0])
      end
    end

    context "when a wall is hit" do
      it "bounces off the wall and continues" do
        create_circle(center: Vector[5, 0], radius: 1, tags: [:wall])
        start = Vector[0, 0]
        direction = Vector[1, 0]
        length = 10

        result = sound_caster.cast_beam(start:, direction:, length:)

        expect(result[:segments].length).to eq(2)
        expect(result[:segments][0][:from]).to eq(Vector[0, 0])
        expect(result[:segments][0][:to][0]).to be_within(0.01).of(4)
      end

      it "reflects correctly off a surface" do
        create_circle(center: Vector[5, 0], radius: 1, tags: [:wall])
        start = Vector[0, 0]
        direction = Vector[1, 0]
        length = 10

        result = sound_caster.cast_beam(start:, direction:, length:)

        expect(result[:segments][1][:to][0]).to be < result[:segments][1][:from][0]
      end
    end

    context "with multiple bounces" do
      it "continues bouncing until length is exhausted" do
        create_circle(center: Vector[5, 0], radius: 1, tags: [:wall])
        create_circle(center: Vector[-5, 0], radius: 1, tags: [:wall])
        start = Vector[0, 0]
        direction = Vector[1, 0]
        length = 30

        result = sound_caster.cast_beam(start:, direction:, length:)

        expect(result[:segments].length).to be >= 3
      end
    end

    context "when a listener is hit" do
      it "records the listener hit" do
        create_circle(center: Vector[5, 0], radius: 1, tags: [:listener])
        start = Vector[0, 0]
        direction = Vector[1, 0]
        length = 10

        result = sound_caster.cast_beam(start:, direction:, length:)
        all_hits = result[:listener_hits].values.flatten

        expect(result[:listener_hits].keys.length).to eq(1)
        expect(all_hits.first).to be_a(SoundHit)
      end

      it "does not bounce off listener" do
        create_circle(center: Vector[5, 0], radius: 1, tags: [:listener])
        start = Vector[0, 0]
        direction = Vector[1, 0]
        length = 10

        result = sound_caster.cast_beam(start:, direction:, length:)

        expect(result[:segments].length).to eq(1)
        expect(result[:segments][0][:to]).to eq(Vector[10, 0])
      end

      it "includes travel_distance in SoundHit" do
        create_circle(center: Vector[5, 0], radius: 1, tags: [:listener])
        start = Vector[0, 0]
        direction = Vector[1, 0]
        length = 10

        result = sound_caster.cast_beam(start:, direction:, length:)
        all_hits = result[:listener_hits].values.flatten

        expect(all_hits.first.travel_distance).to be_within(0.01).of(4)
      end

      it "includes the raycast_hit in SoundHit" do
        create_circle(center: Vector[5, 0], radius: 1, tags: [:listener])
        start = Vector[0, 0]
        direction = Vector[1, 0]
        length = 10

        result = sound_caster.cast_beam(start:, direction:, length:)
        all_hits = result[:listener_hits].values.flatten

        expect(all_hits.first.raycast_hit).to be_a(Physics::RaycastHit)
        expect(all_hits.first.raycast_hit.entry_point[0]).to be_within(0.01).of(4)
      end
    end

    context "with listener behind wall" do
      it "does not register hit on listener behind wall" do
        create_circle(center: Vector[5, 0], radius: 1, tags: [:wall])
        create_circle(center: Vector[10, 0], radius: 1, tags: [:listener])
        start = Vector[0, 0]
        direction = Vector[1, 0]
        length = 15

        result = sound_caster.cast_beam(start:, direction:, length:)

        expect(result[:listener_hits].keys.length).to eq(0)
      end

      it "registers hit on listener in front of wall" do
        create_circle(center: Vector[3, 0], radius: 1, tags: [:listener])
        create_circle(center: Vector[10, 0], radius: 1, tags: [:wall])
        start = Vector[0, 0]
        direction = Vector[1, 0]
        length = 15

        result = sound_caster.cast_beam(start:, direction:, length:)

        expect(result[:listener_hits].keys.length).to eq(1)
      end
    end

    context "with listener after wall bounce" do
      it "accumulates travel_distance through bounces" do
        create_circle(center: Vector[5, 0], radius: 1, tags: [:wall])
        create_circle(center: Vector[-5, 0], radius: 1, tags: [:listener])
        start = Vector[0, 0]
        direction = Vector[1, 0]
        length = 20

        result = sound_caster.cast_beam(start:, direction:, length:)
        all_hits = result[:listener_hits].values.flatten

        expect(result[:listener_hits].keys.length).to eq(1)
        # 4 units to wall + 8 units back to listener = 12 total
        expect(all_hits.first.travel_distance).to be_within(0.1).of(12)
      end
    end

    context "debug lines" do
      it "draws a debug line for each segment" do
        start = Vector[0, 0]
        direction = Vector[1, 0]
        length = 10

        expect(Engine::Debug).to receive(:line).with(
          Vector[0, 0, 0],
          Vector[10, 0, 0],
          color: [1, 1, 1]
        )

        sound_caster.cast_beam(start:, direction:, length:)
      end
    end
  end

  describe "#cast_beams" do
    let(:sound_caster) { SoundCaster.new }

    it "casts the specified number of beams" do
      start = Vector[0, 0]

      expect(sound_caster).to receive(:cast_beam).exactly(8).times.and_call_original

      sound_caster.cast_beams(start:, beam_count: 8, length: 10)
    end

    it "casts beams in evenly spaced directions" do
      start = Vector[0, 0]

      directions = []
      allow(sound_caster).to receive(:cast_beam) do |args|
        directions << args[:direction]
        { segments: [], listener_hits: [] }
      end

      sound_caster.cast_beams(start:, beam_count: 8, length: 10)

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
