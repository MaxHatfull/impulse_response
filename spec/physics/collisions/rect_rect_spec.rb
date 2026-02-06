require "spec_helper"

RSpec.describe Physics::Collisions::RectRect do
  describe ".check" do
    it "returns nil when rects don't overlap" do
      a = create_rect(center: Vector[0, 0], width: 2, height: 2)
      b = create_rect(center: Vector[5, 0], width: 2, height: 2)

      result = Physics::Collisions::RectRect.check(a, b)

      expect(result).to be_nil
    end

    it "returns nil when rects are exactly touching" do
      a = create_rect(center: Vector[0, 0], width: 2, height: 2)
      b = create_rect(center: Vector[2, 0], width: 2, height: 2)

      result = Physics::Collisions::RectRect.check(a, b)

      expect(result).to be_nil
    end

    it "returns collision info when rects overlap" do
      a = create_rect(center: Vector[0, 0], width: 2, height: 2)
      b = create_rect(center: Vector[1.5, 0], width: 2, height: 2)

      result = Physics::Collisions::RectRect.check(a, b)

      expect(result).to be_a(Physics::Collision)
      expect(result.collider_a).to eq(a)
      expect(result.collider_b).to eq(b)
    end

    it "calculates penetration along x axis when x overlap is smaller" do
      a = create_rect(center: Vector[0, 0], width: 2, height: 2)
      b = create_rect(center: Vector[1.5, 0], width: 2, height: 2)

      result = Physics::Collisions::RectRect.check(a, b)

      # x overlap: a extends to 1, b starts at 0.5, overlap = 0.5
      expect(result.penetration).to be_within(0.001).of(0.5)
      expect(result.normal).to eq(Vector[1, 0])
    end

    it "calculates penetration along y axis when y overlap is smaller" do
      a = create_rect(center: Vector[0, 0], width: 2, height: 2)
      b = create_rect(center: Vector[0, 1.5], width: 2, height: 2)

      result = Physics::Collisions::RectRect.check(a, b)

      # y overlap: a extends to 1, b starts at 0.5, overlap = 0.5
      expect(result.penetration).to be_within(0.001).of(0.5)
      expect(result.normal).to eq(Vector[0, 1])
    end

    it "uses negative normal when b is to the left of a" do
      a = create_rect(center: Vector[0, 0], width: 2, height: 2)
      b = create_rect(center: Vector[-1.5, 0], width: 2, height: 2)

      result = Physics::Collisions::RectRect.check(a, b)

      expect(result.normal).to eq(Vector[-1, 0])
    end

    it "uses negative normal when b is below a" do
      a = create_rect(center: Vector[0, 0], width: 2, height: 2)
      b = create_rect(center: Vector[0, -1.5], width: 2, height: 2)

      result = Physics::Collisions::RectRect.check(a, b)

      expect(result.normal).to eq(Vector[0, -1])
    end

    it "calculates contact point at edge of rect a" do
      a = create_rect(center: Vector[0, 0], width: 2, height: 2)
      b = create_rect(center: Vector[1.5, 0], width: 2, height: 2)

      result = Physics::Collisions::RectRect.check(a, b)

      # Contact at right edge of a, centered vertically
      expect(result.contact_point).to eq(Vector[1, 0])
    end
  end
end
