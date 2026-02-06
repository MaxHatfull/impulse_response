require "spec_helper"

RSpec.describe SoundCaster do
  describe "#cast_beam" do
    let(:sound_caster) { SoundCaster.instance }

    context "when no colliders are hit" do
      it "returns a single segment from start to end of length" do
        start = Vector[0, 0]
        direction = Vector[1, 0]
        length = 10

        segments = sound_caster.cast_beam(start:, direction:, length:)

        expect(segments.length).to eq(1)
        expect(segments[0][:from]).to eq(Vector[0, 0])
        expect(segments[0][:to]).to eq(Vector[10, 0])
      end
    end

    context "when a collider is hit" do
      it "bounces off the collider and continues" do
        create_circle(center: Vector[5, 0], radius: 1, tags: [:wall])
        start = Vector[0, 0]
        direction = Vector[1, 0]
        length = 10

        segments = sound_caster.cast_beam(start:, direction:, length:)

        expect(segments.length).to eq(2)
        expect(segments[0][:from]).to eq(Vector[0, 0])
        expect(segments[0][:to][0]).to be_within(0.01).of(4) # hits at x=4
      end

      it "reflects correctly off a surface" do
        # Wall at x=5, ray coming from left
        # Normal will point left (-1, 0), ray goes right (1, 0)
        # Reflection: d - 2(d·n)n = (1,0) - 2(-1)(-1,0) = (1,0) - (2,0) = (-1,0)
        create_circle(center: Vector[5, 0], radius: 1, tags: [:wall])
        start = Vector[0, 0]
        direction = Vector[1, 0]
        length = 10

        segments = sound_caster.cast_beam(start:, direction:, length:)

        # After bouncing, should go back the way it came
        expect(segments[1][:to][0]).to be < segments[1][:from][0]
      end
    end

    context "with multiple bounces" do
      it "continues bouncing until length is exhausted" do
        # Two circles, ray will bounce between them
        create_circle(center: Vector[5, 0], radius: 1, tags: [:wall])
        create_circle(center: Vector[-5, 0], radius: 1, tags: [:wall])
        start = Vector[0, 0]
        direction = Vector[1, 0]
        length = 30

        segments = sound_caster.cast_beam(start:, direction:, length:)

        expect(segments.length).to be >= 3
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
end
