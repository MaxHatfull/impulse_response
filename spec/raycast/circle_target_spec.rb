require "spec_helper"
require_relative "../../impulse_response/loader"

RSpec.describe Raycast::CircleTarget do
  describe "#hit" do
    it "returns nil when the ray misses the circle" do
      circle = Raycast::CircleTarget.create(center: Vector[0, 0], radius: 1)
      ray = Raycast::Ray.new(start_point: Vector[5, 5], direction: Vector[1, 0], length: 10)

      expect(circle.hit(ray)).to be_nil
    end

    it "returns nil when the ray points away from the circle" do
      circle = Raycast::CircleTarget.create(center: Vector[0, 0], radius: 2)
      ray = Raycast::Ray.new(start_point: Vector[5, 0], direction: Vector[1, 0], length: 10)

      expect(circle.hit(ray)).to be_nil
    end

    it "returns nil when the ray is too short to reach the circle" do
      circle = Raycast::CircleTarget.create(center: Vector[10, 0], radius: 1)
      ray = Raycast::Ray.new(start_point: Vector[0, 0], direction: Vector[1, 0], length: 5)

      expect(circle.hit(ray)).to be_nil
    end

    it "returns nil when the ray passes beside an off-center circle" do
      circle = Raycast::CircleTarget.create(center: Vector[3, 5], radius: 1)
      ray = Raycast::Ray.new(start_point: Vector[0, 0], direction: Vector[1, 0], length: 20)

      expect(circle.hit(ray)).to be_nil
    end

    it "returns a hit when the ray hits the circle head on" do
      circle = Raycast::CircleTarget.create(center: Vector[0, 0], radius: 1)
      ray = Raycast::Ray.new(start_point: Vector[-5, 0], direction: Vector[1, 0], length: 10)

      hit = circle.hit(ray)

      expect(hit).to be_a(Raycast::Hit)
      expect(hit.target).to eq(circle)
      expect(hit.point).to eq(Vector[-1, 0])
      expect(hit.distance).to eq(4)
      expect(hit.normal).to eq(Vector[-1, 0])
    end

    it "returns a hit when the ray hits at an angle" do
      circle = Raycast::CircleTarget.create(center: Vector[4, 3], radius: 1)
      ray = Raycast::Ray.new(start_point: Vector[0, 0], direction: Vector[0.8, 0.6], length: 10)

      hit = circle.hit(ray)

      expect(hit).to be_a(Raycast::Hit)
      expect(hit.target).to eq(circle)
      expect(hit.point[0]).to be_within(0.001).of(3.2)
      expect(hit.point[1]).to be_within(0.001).of(2.4)
      expect(hit.distance).to be_within(0.001).of(4)
      expect(hit.normal[0]).to be_within(0.001).of(-0.8)
      expect(hit.normal[1]).to be_within(0.001).of(-0.6)
    end

    it "returns a hit when the ray is tangent to the circle" do
      circle = Raycast::CircleTarget.create(center: Vector[5, 1], radius: 1)
      ray = Raycast::Ray.new(start_point: Vector[0, 0], direction: Vector[1, 0], length: 10)

      hit = circle.hit(ray)

      expect(hit).to be_a(Raycast::Hit)
      expect(hit.point[0]).to be_within(0.001).of(5)
      expect(hit.point[1]).to be_within(0.001).of(0)
      expect(hit.distance).to be_within(0.001).of(5)
    end

    it "returns a hit when the ray length exactly reaches the circle" do
      circle = Raycast::CircleTarget.create(center: Vector[10, 0], radius: 1)
      ray = Raycast::Ray.new(start_point: Vector[0, 0], direction: Vector[1, 0], length: 9)

      hit = circle.hit(ray)

      expect(hit).to be_a(Raycast::Hit)
      expect(hit.distance).to eq(9)
    end

    it "returns nil when the circle is behind the ray start" do
      circle = Raycast::CircleTarget.create(center: Vector[-5, 0], radius: 1)
      ray = Raycast::Ray.new(start_point: Vector[0, 0], direction: Vector[1, 0], length: 10)

      expect(circle.hit(ray)).to be_nil
    end

    it "returns nil when the ray starts inside the circle" do
      circle = Raycast::CircleTarget.create(center: Vector[0, 0], radius: 5)
      ray = Raycast::Ray.new(start_point: Vector[0, 0], direction: Vector[1, 0], length: 10)

      expect(circle.hit(ray)).to be_nil
    end
  end
end
