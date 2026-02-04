require "spec_helper"
require_relative "../../impulse_response/loader"

RSpec.describe Raycast::RectCollider do
  describe "#hit" do
    it "returns nil when the ray misses the rectangle" do
      rect = Raycast::RectCollider.create(center: Vector[0, 0], width: 2, height: 2)
      ray = Raycast::Ray.new(start_point: Vector[5, 5], direction: Vector[1, 0], length: 10)

      expect(rect.hit(ray)).to be_nil
    end

    it "returns a hit when the ray hits the rectangle head on" do
      rect = Raycast::RectCollider.create(center: Vector[5, 0], width: 2, height: 2)
      ray = Raycast::Ray.new(start_point: Vector[0, 0], direction: Vector[1, 0], length: 10)

      hit = rect.hit(ray)

      expect(hit).to be_a(Raycast::Hit)
      expect(hit.collider).to eq(rect)
      expect(hit.point).to eq(Vector[4, 0])
      expect(hit.distance).to eq(4)
      expect(hit.normal).to eq(Vector[-1, 0])
    end

    it "returns nil when the ray is too short to reach the rectangle" do
      rect = Raycast::RectCollider.create(center: Vector[10, 0], width: 2, height: 2)
      ray = Raycast::Ray.new(start_point: Vector[0, 0], direction: Vector[1, 0], length: 5)

      expect(rect.hit(ray)).to be_nil
    end

    it "returns nil when the ray points away from the rectangle" do
      rect = Raycast::RectCollider.create(center: Vector[-5, 0], width: 2, height: 2)
      ray = Raycast::Ray.new(start_point: Vector[0, 0], direction: Vector[1, 0], length: 10)

      expect(rect.hit(ray)).to be_nil
    end

    it "returns a hit when the ray hits at an angle" do
      rect = Raycast::RectCollider.create(center: Vector[5, 5], width: 2, height: 2)
      ray = Raycast::Ray.new(start_point: Vector[0, 0], direction: Vector[1, 1], length: 20)

      hit = rect.hit(ray)

      expect(hit).to be_a(Raycast::Hit)
      expect(hit.collider).to eq(rect)
      expect(hit.point[0]).to be_within(0.001).of(4)
      expect(hit.point[1]).to be_within(0.001).of(4)
      expect(hit.normal).to eq(Vector[-1, 0]).or eq(Vector[0, -1])
    end

    it "returns nil when the ray starts inside the rectangle" do
      rect = Raycast::RectCollider.create(center: Vector[0, 0], width: 4, height: 4)
      ray = Raycast::Ray.new(start_point: Vector[0, 0], direction: Vector[1, 0], length: 10)

      expect(rect.hit(ray)).to be_nil
    end

    it "returns a hit when the ray hits the edge of the rectangle" do
      rect = Raycast::RectCollider.create(center: Vector[5, 1], width: 2, height: 2)
      ray = Raycast::Ray.new(start_point: Vector[0, 0], direction: Vector[1, 0], length: 10)

      hit = rect.hit(ray)

      expect(hit).to be_a(Raycast::Hit)
      expect(hit.point[0]).to be_within(0.001).of(4)
      expect(hit.point[1]).to be_within(0.001).of(0)
    end

    it "returns a hit with correct normal when hitting from above" do
      rect = Raycast::RectCollider.create(center: Vector[0, 0], width: 2, height: 2)
      ray = Raycast::Ray.new(start_point: Vector[0, 5], direction: Vector[0, -1], length: 10)

      hit = rect.hit(ray)

      expect(hit).to be_a(Raycast::Hit)
      expect(hit.point).to eq(Vector[0, 1])
      expect(hit.distance).to eq(4)
      expect(hit.normal).to eq(Vector[0, 1])
    end

    it "returns a hit with correct normal when hitting from below" do
      rect = Raycast::RectCollider.create(center: Vector[0, 0], width: 2, height: 2)
      ray = Raycast::Ray.new(start_point: Vector[0, -5], direction: Vector[0, 1], length: 10)

      hit = rect.hit(ray)

      expect(hit).to be_a(Raycast::Hit)
      expect(hit.point).to eq(Vector[0, -1])
      expect(hit.distance).to eq(4)
      expect(hit.normal).to eq(Vector[0, -1])
    end
  end

  describe "#inside?" do
    it "returns true when the point is inside the rectangle" do
      rect = Raycast::RectCollider.create(center: Vector[0, 0], width: 4, height: 2)

      expect(rect.inside?(Vector[0, 0])).to be true
      expect(rect.inside?(Vector[1, 0.5])).to be true
      expect(rect.inside?(Vector[-1, -0.5])).to be true
    end

    it "returns false when the point is outside the rectangle" do
      rect = Raycast::RectCollider.create(center: Vector[0, 0], width: 4, height: 2)

      expect(rect.inside?(Vector[3, 0])).to be false
      expect(rect.inside?(Vector[0, 2])).to be false
    end

    it "returns false when the point is exactly on the boundary" do
      rect = Raycast::RectCollider.create(center: Vector[0, 0], width: 4, height: 2)

      expect(rect.inside?(Vector[2, 0])).to be false
      expect(rect.inside?(Vector[0, 1])).to be false
    end
  end
end
