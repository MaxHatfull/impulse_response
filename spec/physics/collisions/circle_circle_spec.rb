require "spec_helper"

RSpec.describe Physics::Collisions::CircleCircle do
  describe ".check" do
    it "returns nil when circles don't overlap" do
      a = create_circle(center: Vector[0, 0], radius: 1)
      b = create_circle(center: Vector[5, 0], radius: 1)

      result = Physics::Collisions::CircleCircle.check(a, b)

      expect(result).to be_nil
    end

    it "returns nil when circles are exactly touching" do
      a = create_circle(center: Vector[0, 0], radius: 1)
      b = create_circle(center: Vector[2, 0], radius: 1)

      result = Physics::Collisions::CircleCircle.check(a, b)

      expect(result).to be_nil
    end

    it "returns collision info when circles overlap" do
      a = create_circle(center: Vector[0, 0], radius: 1)
      b = create_circle(center: Vector[1.5, 0], radius: 1)

      result = Physics::Collisions::CircleCircle.check(a, b)

      expect(result).to be_a(Physics::Collision)
      expect(result.collider_a).to eq(a)
      expect(result.collider_b).to eq(b)
    end

    it "calculates correct penetration depth" do
      a = create_circle(center: Vector[0, 0], radius: 1)
      b = create_circle(center: Vector[1.5, 0], radius: 1)

      result = Physics::Collisions::CircleCircle.check(a, b)

      # sum of radii (2) - distance (1.5) = 0.5
      expect(result.penetration).to be_within(0.001).of(0.5)
    end

    it "calculates correct normal pointing from a to b" do
      a = create_circle(center: Vector[0, 0], radius: 1)
      b = create_circle(center: Vector[1.5, 0], radius: 1)

      result = Physics::Collisions::CircleCircle.check(a, b)

      expect(result.normal).to eq(Vector[1, 0])
    end

    it "calculates correct normal for diagonal overlap" do
      a = create_circle(center: Vector[0, 0], radius: 2)
      b = create_circle(center: Vector[1, 1], radius: 2)

      result = Physics::Collisions::CircleCircle.check(a, b)

      expected_normal = Vector[1, 1].normalize
      expect(result.normal[0]).to be_within(0.001).of(expected_normal[0])
      expect(result.normal[1]).to be_within(0.001).of(expected_normal[1])
    end

    it "calculates contact point at the edge of circle a" do
      a = create_circle(center: Vector[0, 0], radius: 1)
      b = create_circle(center: Vector[1.5, 0], radius: 1)

      result = Physics::Collisions::CircleCircle.check(a, b)

      # Contact point is at edge of a, along the normal
      expect(result.contact_point).to eq(Vector[1, 0])
    end
  end
end
