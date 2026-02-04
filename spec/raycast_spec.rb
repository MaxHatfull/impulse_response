require "spec_helper"
require_relative "../impulse_response/loader"

RSpec.describe Raycast do
  before { Raycast.clear_colliders }

  describe ".colliders" do
    it "returns all created raycast colliders" do
      circle = Raycast::CircleCollider.create
      rect = Raycast::RectCollider.create

      expect(Raycast.colliders).to include(circle, rect)
    end

    it "removes colliders when they are destroyed" do
      circle = Raycast::CircleCollider.create
      rect = Raycast::RectCollider.create

      circle.destroy

      expect(Raycast.colliders).not_to include(circle)
      expect(Raycast.colliders).to include(rect)
    end
  end

  describe ".hits" do
    it "returns hits for all colliders the ray intersects" do
      circle1 = Raycast::CircleCollider.create(center: Vector[5, 0], radius: 1)
      circle2 = Raycast::CircleCollider.create(center: Vector[10, 0], radius: 1)
      Raycast::CircleCollider.create(center: Vector[5, 5], radius: 1) # not in path

      ray = Raycast::Ray.new(start_point: Vector[0, 0], direction: Vector[1, 0], length: 20)

      hits = Raycast.hits(ray)

      expect(hits.length).to eq(2)
      expect(hits.map(&:collider)).to contain_exactly(circle1, circle2)
    end

    it "returns an empty array when no colliders are hit" do
      Raycast::CircleCollider.create(center: Vector[5, 5], radius: 1)

      ray = Raycast::Ray.new(start_point: Vector[0, 0], direction: Vector[1, 0], length: 20)

      hits = Raycast.hits(ray)

      expect(hits).to eq([])
    end
  end

  describe ".closest_hit" do
    it "returns the hit with the smallest distance" do
      Raycast::CircleCollider.create(center: Vector[10, 0], radius: 1)
      closest_circle = Raycast::CircleCollider.create(center: Vector[5, 0], radius: 1)
      Raycast::CircleCollider.create(center: Vector[15, 0], radius: 1)

      ray = Raycast::Ray.new(start_point: Vector[0, 0], direction: Vector[1, 0], length: 20)

      hit = Raycast.closest_hit(ray)

      expect(hit).to be_a(Raycast::Hit)
      expect(hit.collider).to eq(closest_circle)
      expect(hit.distance).to eq(4)
    end

    it "returns nil when no colliders are hit" do
      Raycast::CircleCollider.create(center: Vector[5, 5], radius: 1)

      ray = Raycast::Ray.new(start_point: Vector[0, 0], direction: Vector[1, 0], length: 20)

      expect(Raycast.closest_hit(ray)).to be_nil
    end
  end

  describe ".colliders_at" do
    it "returns all colliders containing the point" do
      circle1 = Raycast::CircleCollider.create(center: Vector[0, 0], radius: 5)
      circle2 = Raycast::CircleCollider.create(center: Vector[2, 0], radius: 5)
      Raycast::CircleCollider.create(center: Vector[10, 10], radius: 1)

      colliders = Raycast.colliders_at(Vector[1, 0])

      expect(colliders).to contain_exactly(circle1, circle2)
    end

    it "returns an empty array when no colliders contain the point" do
      Raycast::CircleCollider.create(center: Vector[0, 0], radius: 1)

      colliders = Raycast.colliders_at(Vector[10, 10])

      expect(colliders).to eq([])
    end
  end
end
