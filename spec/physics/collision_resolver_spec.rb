require "spec_helper"
require_relative "../../impulse_response/loader"

RSpec.describe Physics::CollisionResolver do
  before { Physics.clear_colliders }

  describe ".check" do
    it "returns nil when colliders don't overlap" do
      a = create_circle(center: Vector[0, 0], radius: 1)
      b = create_circle(center: Vector[5, 0], radius: 1)

      expect(Physics::CollisionResolver.check(a, b)).to be_nil
    end

    it "dispatches to CircleCircle for two circles" do
      a = create_circle(center: Vector[0, 0], radius: 1)
      b = create_circle(center: Vector[1.5, 0], radius: 1)

      result = Physics::CollisionResolver.check(a, b)

      expect(result).to be_a(Physics::Collision)
      expect(result.penetration).to be_within(0.001).of(0.5)
    end

    it "dispatches to RectRect for two rects" do
      a = create_rect(center: Vector[0, 0], width: 2, height: 2)
      b = create_rect(center: Vector[1.5, 0], width: 2, height: 2)

      result = Physics::CollisionResolver.check(a, b)

      expect(result).to be_a(Physics::Collision)
      expect(result.penetration).to be_within(0.001).of(0.5)
    end

    it "dispatches to CircleRect for circle and rect" do
      circle = create_circle(center: Vector[0, 0], radius: 1)
      rect = create_rect(center: Vector[1.5, 0], width: 2, height: 2)

      result = Physics::CollisionResolver.check(circle, rect)

      expect(result).to be_a(Physics::Collision)
      expect(result.collider_a).to eq(circle)
      expect(result.collider_b).to eq(rect)
    end

    it "dispatches to CircleRect for rect and circle (reversed order)" do
      rect = create_rect(center: Vector[1.5, 0], width: 2, height: 2)
      circle = create_circle(center: Vector[0, 0], radius: 1)

      result = Physics::CollisionResolver.check(rect, circle)

      expect(result).to be_a(Physics::Collision)
      expect(result.collider_a).to eq(rect)
      expect(result.collider_b).to eq(circle)
    end
  end
end
