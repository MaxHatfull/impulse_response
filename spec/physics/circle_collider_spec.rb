require "spec_helper"
require_relative "../../impulse_response/loader"

RSpec.describe Physics::CircleCollider do
  describe "#raycast" do
    it "returns nil when the ray misses the circle" do
      circle = create_circle(center: Vector[0, 0], radius: 1)
      ray = Physics::Ray.new(start_point: Vector[5, 5], direction: Vector[1, 0], length: 10)

      expect(circle.raycast(ray)).to be_nil
    end

    it "returns nil when the ray points away from the circle" do
      circle = create_circle(center: Vector[0, 0], radius: 2)
      ray = Physics::Ray.new(start_point: Vector[5, 0], direction: Vector[1, 0], length: 10)

      expect(circle.raycast(ray)).to be_nil
    end

    it "returns nil when the ray is too short to reach the circle" do
      circle = create_circle(center: Vector[10, 0], radius: 1)
      ray = Physics::Ray.new(start_point: Vector[0, 0], direction: Vector[1, 0], length: 5)

      expect(circle.raycast(ray)).to be_nil
    end

    it "returns nil when the ray passes beside an off-center circle" do
      circle = create_circle(center: Vector[3, 5], radius: 1)
      ray = Physics::Ray.new(start_point: Vector[0, 0], direction: Vector[1, 0], length: 20)

      expect(circle.raycast(ray)).to be_nil
    end

    it "returns a hit when the ray hits the circle head on" do
      circle = create_circle(center: Vector[0, 0], radius: 1)
      ray = Physics::Ray.new(start_point: Vector[-5, 0], direction: Vector[1, 0], length: 10)

      hit = circle.raycast(ray)

      expect(hit).to be_a(Physics::RaycastHit)
      expect(hit.collider).to eq(circle)
      expect(hit.point).to eq(Vector[-1, 0])
      expect(hit.distance).to eq(4)
      expect(hit.normal).to eq(Vector[-1, 0])
    end

    it "returns a hit when the ray hits at an angle" do
      circle = create_circle(center: Vector[4, 3], radius: 1)
      ray = Physics::Ray.new(start_point: Vector[0, 0], direction: Vector[0.8, 0.6], length: 10)

      hit = circle.raycast(ray)

      expect(hit).to be_a(Physics::RaycastHit)
      expect(hit.collider).to eq(circle)
      expect(hit.point[0]).to be_within(0.001).of(3.2)
      expect(hit.point[1]).to be_within(0.001).of(2.4)
      expect(hit.distance).to be_within(0.001).of(4)
      expect(hit.normal[0]).to be_within(0.001).of(-0.8)
      expect(hit.normal[1]).to be_within(0.001).of(-0.6)
    end

    it "returns a hit when the ray is tangent to the circle" do
      circle = create_circle(center: Vector[5, 1], radius: 1)
      ray = Physics::Ray.new(start_point: Vector[0, 0], direction: Vector[1, 0], length: 10)

      hit = circle.raycast(ray)

      expect(hit).to be_a(Physics::RaycastHit)
      expect(hit.point[0]).to be_within(0.001).of(5)
      expect(hit.point[1]).to be_within(0.001).of(0)
      expect(hit.distance).to be_within(0.001).of(5)
    end

    it "returns a hit when the ray length exactly reaches the circle" do
      circle = create_circle(center: Vector[10, 0], radius: 1)
      ray = Physics::Ray.new(start_point: Vector[0, 0], direction: Vector[1, 0], length: 9)

      hit = circle.raycast(ray)

      expect(hit).to be_a(Physics::RaycastHit)
      expect(hit.distance).to eq(9)
    end

    it "returns nil when the circle is behind the ray start" do
      circle = create_circle(center: Vector[-5, 0], radius: 1)
      ray = Physics::Ray.new(start_point: Vector[0, 0], direction: Vector[1, 0], length: 10)

      expect(circle.raycast(ray)).to be_nil
    end

    it "returns nil when the ray starts inside the circle" do
      circle = create_circle(center: Vector[0, 0], radius: 5)
      ray = Physics::Ray.new(start_point: Vector[0, 0], direction: Vector[1, 0], length: 10)

      expect(circle.raycast(ray)).to be_nil
    end
  end

  describe "#inside?" do
    it "returns true when the point is inside the circle" do
      circle = create_circle(center: Vector[0, 0], radius: 5)

      expect(circle.inside?(Vector[0, 0])).to be true
      expect(circle.inside?(Vector[2, 2])).to be true
      expect(circle.inside?(Vector[4, 0])).to be true
    end

    it "returns false when the point is outside the circle" do
      circle = create_circle(center: Vector[0, 0], radius: 5)

      expect(circle.inside?(Vector[6, 0])).to be false
      expect(circle.inside?(Vector[4, 4])).to be false
    end

    it "returns false when the point is exactly on the boundary" do
      circle = create_circle(center: Vector[0, 0], radius: 5)

      expect(circle.inside?(Vector[5, 0])).to be false
    end
  end
end
