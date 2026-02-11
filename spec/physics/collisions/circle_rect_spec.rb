RSpec.describe Physics::Collisions::CircleRect do
  describe ".check" do
    it "returns nil when circle and rect don't overlap" do
      circle = create_circle(center: Vector[0, 0], radius: 1)
      rect = create_rect(center: Vector[5, 0], width: 2, height: 2)

      result = Physics::Collisions::CircleRect.check(circle, rect)

      expect(result).to be_nil
    end

    it "returns nil when circle and rect are exactly touching" do
      circle = create_circle(center: Vector[0, 0], radius: 1)
      rect = create_rect(center: Vector[2, 0], width: 2, height: 2)

      result = Physics::Collisions::CircleRect.check(circle, rect)

      expect(result).to be_nil
    end

    it "returns collision info when circle overlaps rect from the side" do
      circle = create_circle(center: Vector[0, 0], radius: 1)
      rect = create_rect(center: Vector[1.5, 0], width: 2, height: 2)

      result = Physics::Collisions::CircleRect.check(circle, rect)

      expect(result).to be_a(Physics::Collision)
      expect(result.collider_a).to eq(circle)
      expect(result.collider_b).to eq(rect)
    end

    it "calculates correct penetration when hitting from the side" do
      circle = create_circle(center: Vector[0, 0], radius: 1)
      rect = create_rect(center: Vector[1.5, 0], width: 2, height: 2)

      result = Physics::Collisions::CircleRect.check(circle, rect)

      # Closest point on rect is (0.5, 0), distance to circle center is 0.5
      # Penetration = radius (1) - distance (0.5) = 0.5
      expect(result.penetration).to be_within(0.001).of(0.5)
      expect(result.normal).to eq(Vector[1, 0])
    end

    it "calculates correct penetration when hitting from above" do
      circle = create_circle(center: Vector[0, 2], radius: 1)
      rect = create_rect(center: Vector[0, 0], width: 2, height: 2)

      result = Physics::Collisions::CircleRect.check(circle, rect)

      # Closest point on rect is (0, 1), distance to circle center is 1
      # Penetration = radius (1) - distance (1) = 0, but they overlap slightly
      expect(result).to be_nil
    end

    it "calculates correct collision when circle overlaps rect corner" do
      circle = create_circle(center: Vector[2, 2], radius: 1)
      rect = create_rect(center: Vector[0, 0], width: 2, height: 2)

      result = Physics::Collisions::CircleRect.check(circle, rect)

      # Closest point on rect is corner (1, 1)
      # Distance from (2,2) to (1,1) = sqrt(2) ≈ 1.414
      # radius (1) < distance, so no collision
      expect(result).to be_nil
    end

    it "returns collision when circle overlaps rect corner" do
      circle = create_circle(center: Vector[1.5, 1.5], radius: 1)
      rect = create_rect(center: Vector[0, 0], width: 2, height: 2)

      result = Physics::Collisions::CircleRect.check(circle, rect)

      # Closest point on rect is corner (1, 1)
      # Distance from (1.5, 1.5) to (1, 1) = sqrt(0.5) ≈ 0.707
      # Penetration = 1 - 0.707 ≈ 0.293
      expect(result).to be_a(Physics::Collision)
      expect(result.penetration).to be_within(0.001).of(1 - Math.sqrt(0.5))

      expected_normal = Vector[-1, -1].normalize
      expect(result.normal[0]).to be_within(0.001).of(expected_normal[0])
      expect(result.normal[1]).to be_within(0.001).of(expected_normal[1])
    end

    it "handles circle center inside rect" do
      circle = create_circle(center: Vector[0, 0], radius: 1)
      rect = create_rect(center: Vector[0, 0], width: 4, height: 4)

      result = Physics::Collisions::CircleRect.check(circle, rect)

      # Circle center is inside rect, should still detect collision
      # Push out along shortest axis
      expect(result).to be_a(Physics::Collision)
    end

    it "calculates contact point at edge of circle" do
      circle = create_circle(center: Vector[0, 0], radius: 1)
      rect = create_rect(center: Vector[1.5, 0], width: 2, height: 2)

      result = Physics::Collisions::CircleRect.check(circle, rect)

      # Contact point is at edge of circle toward the rect
      expect(result.contact_point[0]).to be_within(0.001).of(1)
      expect(result.contact_point[1]).to be_within(0.001).of(0)
    end

    context "with rotated rect" do
      it "returns nil when circle misses rotated rect" do
        # 4x2 rect rotated 90 degrees (becomes 2x4)
        # Circle at (2, 0) with radius 0.5 would hit unrotated but misses rotated
        circle = create_circle(center: Vector[2, 0], radius: 0.5)
        rect = create_rect(center: Vector[0, 0], width: 4, height: 2, rotation: Math::PI / 2)

        result = Physics::Collisions::CircleRect.check(circle, rect)

        # Rotated rect only extends from x=-1 to x=1, circle at x=2 misses
        expect(result).to be_nil
      end

      it "returns collision when circle hits rotated rect" do
        # 4x2 rect rotated 90 degrees (becomes 2x4)
        circle = create_circle(center: Vector[1.5, 0], radius: 1)
        rect = create_rect(center: Vector[0, 0], width: 4, height: 2, rotation: Math::PI / 2)

        result = Physics::Collisions::CircleRect.check(circle, rect)

        # Circle at x=1.5 with radius 1 overlaps rect edge at x=1
        expect(result).to be_a(Physics::Collision)
        expect(result.penetration).to be_within(0.001).of(0.5)
      end

      it "returns correct normal for rotated rect" do
        # 4x2 rect rotated 90 degrees (becomes 2x4)
        circle = create_circle(center: Vector[1.5, 0], radius: 1)
        rect = create_rect(center: Vector[0, 0], width: 4, height: 2, rotation: Math::PI / 2)

        result = Physics::Collisions::CircleRect.check(circle, rect)

        # Normal points from circle toward rect (the penetration direction)
        # Circle is to the right, rect is to the left, so normal points left
        expect(result.normal[0]).to be_within(0.001).of(-1)
        expect(result.normal[1]).to be_within(0.001).of(0)
      end

      it "handles 45-degree rotated rect" do
        # 4x2 rect rotated 45 degrees
        # Circle at (2, 2) would miss unrotated rect but hits rotated
        circle = create_circle(center: Vector[1.2, 1.2], radius: 0.5)
        rect = create_rect(center: Vector[0, 0], width: 4, height: 2, rotation: Math::PI / 4)

        result = Physics::Collisions::CircleRect.check(circle, rect)

        # The rotated rect extends diagonally, circle should hit
        expect(result).to be_a(Physics::Collision)
      end
    end
  end
end
