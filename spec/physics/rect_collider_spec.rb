RSpec.describe Physics::RectCollider do
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
  end
end
