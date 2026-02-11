RSpec.describe Physics::RectCollider do
  describe "#rotation" do
    it "defaults to 0" do
      rect = create_rect(center: Vector[0, 0], width: 2, height: 2)
      expect(rect.rotation).to eq(0)
    end

    it "can be set to a custom value" do
      rect = create_rect(center: Vector[0, 0], width: 2, height: 2, rotation: Math::PI / 4)
      expect(rect.rotation).to eq(Math::PI / 4)
    end
  end

  describe "#aabb" do
    it "returns correct aabb for unrotated rect" do
      rect = create_rect(center: Vector[0, 0], width: 4, height: 2)
      aabb = rect.aabb

      expect(aabb.min_x).to eq(-2)
      expect(aabb.max_x).to eq(2)
      expect(aabb.min_y).to eq(-1)
      expect(aabb.max_y).to eq(1)
    end

    it "returns expanded aabb for 45-degree rotated rect" do
      # A 4x2 rect rotated 45 degrees
      # At 45°, the corners rotate to new positions
      # Corner (2,1) rotates to (2*cos45 - 1*sin45, 2*sin45 + 1*cos45) = (0.707, 2.121)
      # Corner (2,-1) rotates to (2*cos45 + 1*sin45, 2*sin45 - 1*cos45) = (2.121, 0.707)
      rect = create_rect(center: Vector[0, 0], width: 4, height: 2, rotation: Math::PI / 4)
      aabb = rect.aabb

      # Max extent is (half_width + half_height) * cos(45°) = 3 * 0.7071 ≈ 2.121
      extent = (2 + 1) * Math.cos(Math::PI / 4)
      expect(aabb.min_x).to be_within(0.001).of(-extent)
      expect(aabb.max_x).to be_within(0.001).of(extent)
      expect(aabb.min_y).to be_within(0.001).of(-extent)
      expect(aabb.max_y).to be_within(0.001).of(extent)
    end

    it "returns correct aabb for 90-degree rotated rect" do
      # A 4x2 rect rotated 90 degrees becomes effectively 2x4
      rect = create_rect(center: Vector[0, 0], width: 4, height: 2, rotation: Math::PI / 2)
      aabb = rect.aabb

      expect(aabb.min_x).to be_within(0.001).of(-1)
      expect(aabb.max_x).to be_within(0.001).of(1)
      expect(aabb.min_y).to be_within(0.001).of(-2)
      expect(aabb.max_y).to be_within(0.001).of(2)
    end
  end

  describe "#raycast" do
    it "returns nil when the ray misses the rectangle" do
      rect = create_rect(center: Vector[0, 0], width: 2, height: 2)
      ray = Physics::Ray.new(start_point: Vector[5, 5], direction: Vector[1, 0], length: 10)

      expect(rect.raycast(ray)).to be_nil
    end

    it "returns a hit when the ray hits the rectangle head on" do
      rect = create_rect(center: Vector[5, 0], width: 2, height: 2)
      ray = Physics::Ray.new(start_point: Vector[0, 0], direction: Vector[1, 0], length: 10)

      hit = rect.raycast(ray)

      expect(hit).to be_a(Physics::RaycastHit)
      expect(hit.collider).to eq(rect)
      expect(hit.ray).to eq(ray)
      expect(hit.entry_point).to eq(Vector[4, 0])
      expect(hit.exit_point).to eq(Vector[6, 0])
      expect(hit.entry_distance).to eq(4)
      expect(hit.entry_normal).to eq(Vector[-1, 0])
      expect(hit.exit_normal).to eq(Vector[1, 0])
    end

    it "returns nil when the ray is too short to reach the rectangle" do
      rect = create_rect(center: Vector[10, 0], width: 2, height: 2)
      ray = Physics::Ray.new(start_point: Vector[0, 0], direction: Vector[1, 0], length: 5)

      expect(rect.raycast(ray)).to be_nil
    end

    it "returns nil when the ray points away from the rectangle" do
      rect = create_rect(center: Vector[-5, 0], width: 2, height: 2)
      ray = Physics::Ray.new(start_point: Vector[0, 0], direction: Vector[1, 0], length: 10)

      expect(rect.raycast(ray)).to be_nil
    end

    it "returns a hit when the ray hits at an angle" do
      rect = create_rect(center: Vector[5, 5], width: 2, height: 2)
      ray = Physics::Ray.new(start_point: Vector[0, 0], direction: Vector[1, 1], length: 20)

      hit = rect.raycast(ray)

      expect(hit).to be_a(Physics::RaycastHit)
      expect(hit.collider).to eq(rect)
      expect(hit.entry_point[0]).to be_within(0.001).of(4)
      expect(hit.entry_point[1]).to be_within(0.001).of(4)
      expect(hit.entry_normal).to eq(Vector[-1, 0]).or eq(Vector[0, -1])
      expect(hit.exit_point[0]).to be_within(0.001).of(6)
      expect(hit.exit_point[1]).to be_within(0.001).of(6)
      expect(hit.exit_normal).to eq(Vector[1, 0]).or eq(Vector[0, 1])
    end

    it "returns a hit when the ray hits the edge of the rectangle" do
      rect = create_rect(center: Vector[5, 1], width: 2, height: 2)
      ray = Physics::Ray.new(start_point: Vector[0, 0], direction: Vector[1, 0], length: 10)

      hit = rect.raycast(ray)

      expect(hit).to be_a(Physics::RaycastHit)
      expect(hit.entry_point[0]).to be_within(0.001).of(4)
      expect(hit.entry_point[1]).to be_within(0.001).of(0)
    end

    it "returns a hit with correct normal when hitting from above" do
      rect = create_rect(center: Vector[0, 0], width: 2, height: 2)
      ray = Physics::Ray.new(start_point: Vector[0, 5], direction: Vector[0, -1], length: 10)

      hit = rect.raycast(ray)

      expect(hit).to be_a(Physics::RaycastHit)
      expect(hit.entry_point).to eq(Vector[0, 1])
      expect(hit.exit_point).to eq(Vector[0, -1])
      expect(hit.entry_distance).to eq(4)
      expect(hit.entry_normal).to eq(Vector[0, 1])
      expect(hit.exit_normal).to eq(Vector[0, -1])
    end

    it "returns a hit with correct normal when hitting from below" do
      rect = create_rect(center: Vector[0, 0], width: 2, height: 2)
      ray = Physics::Ray.new(start_point: Vector[0, -5], direction: Vector[0, 1], length: 10)

      hit = rect.raycast(ray)

      expect(hit).to be_a(Physics::RaycastHit)
      expect(hit.entry_point).to eq(Vector[0, -1])
      expect(hit.exit_point).to eq(Vector[0, 1])
      expect(hit.entry_distance).to eq(4)
      expect(hit.entry_normal).to eq(Vector[0, -1])
      expect(hit.exit_normal).to eq(Vector[0, 1])
    end

    describe "when ray starts inside the rectangle" do
      it "returns a hit with entry at ray start and nil entry_normal" do
        rect = create_rect(center: Vector[0, 0], width: 4, height: 4)
        ray = Physics::Ray.new(start_point: Vector[0, 0], direction: Vector[1, 0], length: 10)

        hit = rect.raycast(ray)

        expect(hit).to be_a(Physics::RaycastHit)
        expect(hit.entry_point).to eq(Vector[0, 0])
        expect(hit.entry_normal).to be_nil
        expect(hit.exit_point).to eq(Vector[2, 0])
        expect(hit.exit_normal).to eq(Vector[1, 0])
      end

      it "works when starting off-center inside the rectangle" do
        rect = create_rect(center: Vector[0, 0], width: 6, height: 4)
        ray = Physics::Ray.new(start_point: Vector[1, 0], direction: Vector[1, 0], length: 10)

        hit = rect.raycast(ray)

        expect(hit).to be_a(Physics::RaycastHit)
        expect(hit.entry_point).to eq(Vector[1, 0])
        expect(hit.entry_normal).to be_nil
        expect(hit.exit_point).to eq(Vector[3, 0])
        expect(hit.exit_normal).to eq(Vector[1, 0])
      end
    end

    describe "when ray ends inside the rectangle" do
      it "returns a hit with exit at ray end and nil exit_normal" do
        rect = create_rect(center: Vector[5, 0], width: 6, height: 4)
        ray = Physics::Ray.new(start_point: Vector[0, 0], direction: Vector[1, 0], length: 5)

        hit = rect.raycast(ray)

        expect(hit).to be_a(Physics::RaycastHit)
        expect(hit.entry_point).to eq(Vector[2, 0])
        expect(hit.entry_normal).to eq(Vector[-1, 0])
        expect(hit.exit_point).to eq(Vector[5, 0])
        expect(hit.exit_normal).to be_nil
      end
    end

    describe "with rotation" do
      it "misses a rotated rect that an unrotated ray would hit" do
        # 4x2 rect at origin, rotated 45 degrees
        # Y extent of rotated rect is about ±2.12, so y=2.5 misses
        rect = create_rect(center: Vector[0, 0], width: 4, height: 2, rotation: Math::PI / 4)
        ray = Physics::Ray.new(start_point: Vector[-5, 2.5], direction: Vector[1, 0], length: 10)

        expect(rect.raycast(ray)).to be_nil
      end

      it "hits a rotated rect with correct entry point" do
        # 4x2 rect at origin, rotated 90 degrees (now effectively 2x4)
        rect = create_rect(center: Vector[0, 0], width: 4, height: 2, rotation: Math::PI / 2)
        ray = Physics::Ray.new(start_point: Vector[-5, 0], direction: Vector[1, 0], length: 10)

        hit = rect.raycast(ray)

        expect(hit).to be_a(Physics::RaycastHit)
        # Rotated 90°, width becomes height, so entry is at x = -1 (half of original height)
        expect(hit.entry_point[0]).to be_within(0.001).of(-1)
        expect(hit.entry_point[1]).to be_within(0.001).of(0)
        expect(hit.exit_point[0]).to be_within(0.001).of(1)
        expect(hit.exit_point[1]).to be_within(0.001).of(0)
      end

      it "returns correct normals for rotated rect" do
        # 4x2 rect rotated 90 degrees (becomes 2x4 in world)
        # Ray from left hits the left face (which was the top face before rotation)
        rect = create_rect(center: Vector[0, 0], width: 4, height: 2, rotation: Math::PI / 2)
        ray = Physics::Ray.new(start_point: Vector[-5, 0], direction: Vector[1, 0], length: 10)

        hit = rect.raycast(ray)

        # In local space, ray comes from above and hits top face with normal (0, 1)
        # Rotating (0, 1) by 90° gives (-1, 0)
        expect(hit.entry_normal[0]).to be_within(0.001).of(-1)
        expect(hit.entry_normal[1]).to be_within(0.001).of(0)
        expect(hit.exit_normal[0]).to be_within(0.001).of(1)
        expect(hit.exit_normal[1]).to be_within(0.001).of(0)
      end

      it "hits a 45-degree rotated rect" do
        # 4x2 rect rotated 45 degrees
        rect = create_rect(center: Vector[0, 0], width: 4, height: 2, rotation: Math::PI / 4)
        # Ray going diagonally, aligned with the rotated rect's long axis
        ray = Physics::Ray.new(start_point: Vector[-3, -3], direction: Vector[1, 1].normalize, length: 10)

        hit = rect.raycast(ray)

        expect(hit).to be_a(Physics::RaycastHit)
        expect(hit.entry_point).not_to be_nil
      end
    end
  end

  describe "#inside?" do
    it "returns true when the point is inside the rectangle" do
      rect = create_rect(center: Vector[0, 0], width: 4, height: 2)

      expect(rect.inside?(Vector[0, 0])).to be true
      expect(rect.inside?(Vector[1, 0.5])).to be true
      expect(rect.inside?(Vector[-1, -0.5])).to be true
    end

    it "returns false when the point is outside the rectangle" do
      rect = create_rect(center: Vector[0, 0], width: 4, height: 2)

      expect(rect.inside?(Vector[3, 0])).to be false
      expect(rect.inside?(Vector[0, 2])).to be false
    end

    it "returns false when the point is exactly on the boundary" do
      rect = create_rect(center: Vector[0, 0], width: 4, height: 2)

      expect(rect.inside?(Vector[2, 0])).to be false
      expect(rect.inside?(Vector[0, 1])).to be false
    end

    context "with rotation" do
      it "returns true for point inside rotated rect" do
        # 4x2 rect rotated 45 degrees - center is still inside
        rect = create_rect(center: Vector[0, 0], width: 4, height: 2, rotation: Math::PI / 4)

        expect(rect.inside?(Vector[0, 0])).to be true
        expect(rect.inside?(Vector[0.5, 0.5])).to be true
      end

      it "returns false for point outside rotated rect but inside original AABB" do
        # Point (1.5, 0) is inside original 4x2 AABB but outside rotated shape
        rect = create_rect(center: Vector[0, 0], width: 4, height: 2, rotation: Math::PI / 4)

        # (1.5, 0) in world -> rotate by -45° to local space
        # local_x = 1.5 * cos(-45) - 0 * sin(-45) = 1.5 * 0.707 ≈ 1.06
        # local_y = 1.5 * sin(-45) + 0 * cos(-45) = 1.5 * -0.707 ≈ -1.06
        # This is outside half_height=1, so should be false
        expect(rect.inside?(Vector[1.5, 0])).to be false
      end

      it "returns true for point inside rotated rect but outside original AABB" do
        # A 4x2 rect rotated 45 degrees extends diagonally
        # Point (1.4, 1.4) is outside original AABB but inside the rotated shape
        rect = create_rect(center: Vector[0, 0], width: 4, height: 2, rotation: Math::PI / 4)

        # (1.4, 1.4) rotated by -45° to local space:
        # local_x = 1.4 * cos(-45) - 1.4 * sin(-45) = 1.4*0.707 + 1.4*0.707 ≈ 1.98
        # local_y = 1.4 * sin(-45) + 1.4 * cos(-45) = -1.4*0.707 + 1.4*0.707 = 0
        # 1.98 < half_width=2, 0 < half_height=1, so inside
        expect(rect.inside?(Vector[1.4, 1.4])).to be true
      end
    end
  end
end
