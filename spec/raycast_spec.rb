require "spec_helper"
require_relative "../impulse_response/loader"

RSpec.describe Raycast do
  before { Raycast.clear_targets }

  describe ".targets" do
    it "returns all created raycast targets" do
      circle = Raycast::CircleTarget.create
      rect = Raycast::RectTarget.create

      expect(Raycast.targets).to include(circle, rect)
    end

    it "removes targets when they are destroyed" do
      circle = Raycast::CircleTarget.create
      rect = Raycast::RectTarget.create

      circle.destroy

      expect(Raycast.targets).not_to include(circle)
      expect(Raycast.targets).to include(rect)
    end
  end

  describe ".test" do
    it "returns hits for all targets the ray intersects" do
      circle1 = Raycast::CircleTarget.create(center: Vector[5, 0], radius: 1)
      circle2 = Raycast::CircleTarget.create(center: Vector[10, 0], radius: 1)
      circle3 = Raycast::CircleTarget.create(center: Vector[5, 5], radius: 1) # not in path

      ray = Raycast::Ray.new(start_point: Vector[0, 0], direction: Vector[1, 0], length: 20)

      hits = Raycast.test(ray)

      expect(hits.length).to eq(2)
      expect(hits.map(&:target)).to contain_exactly(circle1, circle2)
    end

    it "returns an empty array when no targets are hit" do
      Raycast::CircleTarget.create(center: Vector[5, 5], radius: 1)

      ray = Raycast::Ray.new(start_point: Vector[0, 0], direction: Vector[1, 0], length: 20)

      hits = Raycast.test(ray)

      expect(hits).to eq([])
    end
  end
end
