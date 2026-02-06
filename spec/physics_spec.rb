require "spec_helper"
require_relative "../impulse_response/loader"

RSpec.describe Physics do
  before { Physics.clear_colliders }

  describe "registration" do
    it "registers colliders in the quadtree" do
      circle = create_circle(center: Vector[0, 0], radius: 1)
      rect = create_rect(center: Vector[0, 0], width: 1, height: 1)

      found = Physics.colliders_at(Vector[0, 0])
      expect(found).to include(circle, rect)
    end

    it "removes colliders from quadtree when destroyed" do
      circle = create_circle(center: Vector[0, 0], radius: 1)
      rect = create_rect(center: Vector[0, 0], width: 1, height: 1)

      circle.destroy

      found = Physics.colliders_at(Vector[0, 0])
      expect(found).not_to include(circle)
      expect(found).to include(rect)
    end

    it "registers tagged colliders in tag-specific quadtrees" do
      wall = create_circle(center: Vector[0, 0], radius: 1, tags: [:wall])
      enemy = create_circle(center: Vector[0, 0], radius: 1, tags: [:enemy])

      expect(Physics.colliders_at(Vector[0, 0], tag: :wall)).to eq([wall])
      expect(Physics.colliders_at(Vector[0, 0], tag: :enemy)).to eq([enemy])
    end

    it "registers colliders with multiple tags in multiple quadtrees" do
      multi = create_circle(center: Vector[0, 0], radius: 1, tags: [:wall, :solid])

      expect(Physics.colliders_at(Vector[0, 0], tag: :wall)).to eq([multi])
      expect(Physics.colliders_at(Vector[0, 0], tag: :solid)).to eq([multi])
    end

    it "returns all colliders when no tag specified" do
      untagged = create_circle(center: Vector[0, 0], radius: 1)
      tagged = create_circle(center: Vector[0, 0], radius: 1, tags: [:wall])

      expect(Physics.colliders_at(Vector[0, 0])).to contain_exactly(untagged, tagged)
      expect(Physics.colliders_at(Vector[0, 0], tag: :wall)).to eq([tagged])
    end

    it "removes tagged colliders from the quadtree when destroyed" do
      multi = create_circle(center: Vector[0, 0], radius: 1, tags: [:wall, :solid])
      multi.destroy

      expect(Physics.colliders_at(Vector[0, 0])).to eq([])
      expect(Physics.colliders_at(Vector[0, 0], tag: :wall)).to eq([])
      expect(Physics.colliders_at(Vector[0, 0], tag: :solid)).to eq([])
    end
  end

  describe ".raycast" do
    it "returns hits for all colliders the ray intersects" do
      circle1 = create_circle(center: Vector[5, 0], radius: 1)
      circle2 = create_circle(center: Vector[10, 0], radius: 1)
      create_circle(center: Vector[5, 5], radius: 1) # not in path

      ray = Physics::Ray.new(start_point: Vector[0, 0], direction: Vector[1, 0], length: 20)

      hits = Physics.raycast(ray)

      expect(hits.length).to eq(2)
      expect(hits.map(&:collider)).to contain_exactly(circle1, circle2)
    end

    it "returns an empty array when no colliders are hit" do
      create_circle(center: Vector[5, 5], radius: 1)

      ray = Physics::Ray.new(start_point: Vector[0, 0], direction: Vector[1, 0], length: 20)

      hits = Physics.raycast(ray)

      expect(hits).to eq([])
    end

    it "only returns hits for colliders with the specified tag" do
      wall = create_circle(center: Vector[5, 0], radius: 1, tags: [:wall])
      create_circle(center: Vector[10, 0], radius: 1, tags: [:enemy])

      ray = Physics::Ray.new(start_point: Vector[0, 0], direction: Vector[1, 0], length: 20)

      hits = Physics.raycast(ray, tag: :wall)

      expect(hits.length).to eq(1)
      expect(hits.first.collider).to eq(wall)
    end
  end

  describe ".closest_raycast" do
    it "returns the hit with the smallest distance" do
      create_circle(center: Vector[10, 0], radius: 1)
      closest_circle = create_circle(center: Vector[5, 0], radius: 1)
      create_circle(center: Vector[15, 0], radius: 1)

      ray = Physics::Ray.new(start_point: Vector[0, 0], direction: Vector[1, 0], length: 20)

      hit = Physics.closest_raycast(ray)

      expect(hit).to be_a(Physics::RaycastHit)
      expect(hit.collider).to eq(closest_circle)
      expect(hit.distance).to eq(4)
    end

    it "returns nil when no colliders are hit" do
      create_circle(center: Vector[5, 5], radius: 1)

      ray = Physics::Ray.new(start_point: Vector[0, 0], direction: Vector[1, 0], length: 20)

      expect(Physics.closest_raycast(ray)).to be_nil
    end

    it "returns the closest hit for the specified tag only" do
      create_circle(center: Vector[5, 0], radius: 1, tags: [:enemy]) # closer but wrong tag
      wall = create_circle(center: Vector[10, 0], radius: 1, tags: [:wall])

      ray = Physics::Ray.new(start_point: Vector[0, 0], direction: Vector[1, 0], length: 20)

      hit = Physics.closest_raycast(ray, tag: :wall)

      expect(hit.collider).to eq(wall)
    end
  end

  describe ".colliders_at" do
    it "returns all colliders containing the point" do
      circle1 = create_circle(center: Vector[0, 0], radius: 5)
      circle2 = create_circle(center: Vector[2, 0], radius: 5)
      create_circle(center: Vector[10, 10], radius: 1)

      colliders = Physics.colliders_at(Vector[1, 0])

      expect(colliders).to contain_exactly(circle1, circle2)
    end

    it "returns an empty array when no colliders contain the point" do
      create_circle(center: Vector[0, 0], radius: 1)

      colliders = Physics.colliders_at(Vector[10, 10])

      expect(colliders).to eq([])
    end
  end

  describe ".collisions" do
    it "returns all collisions for a given collider" do
      target = create_circle(center: Vector[0, 0], radius: 1)
      hit1 = create_circle(center: Vector[1.5, 0], radius: 1)
      hit2 = create_rect(center: Vector[0, 1.5], width: 2, height: 2)
      create_circle(center: Vector[10, 10], radius: 1) # not overlapping

      collisions = Physics.collisions(target)

      expect(collisions.length).to eq(2)
      expect(collisions.map(&:collider_b)).to contain_exactly(hit1, hit2)
      expect(collisions).to all(be_a(Physics::Collision))
    end

    it "returns an empty array when no collisions" do
      target = create_circle(center: Vector[0, 0], radius: 1)
      create_circle(center: Vector[10, 0], radius: 1)

      collisions = Physics.collisions(target)

      expect(collisions).to eq([])
    end

    it "does not include self-collision" do
      target = create_circle(center: Vector[0, 0], radius: 1)

      collisions = Physics.collisions(target)

      expect(collisions).to eq([])
    end
  end
end
