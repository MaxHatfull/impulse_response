RSpec.describe Physics::AABB do
  describe "#contains_point?" do
    let(:aabb) { Physics::AABB.new(0, 0, 10, 10) }

    it "returns true for points inside" do
      expect(aabb.contains_point?(Vector[5, 5])).to be true
    end

    it "returns true for points on edge" do
      expect(aabb.contains_point?(Vector[0, 5])).to be true
      expect(aabb.contains_point?(Vector[10, 5])).to be true
    end

    it "returns false for points outside" do
      expect(aabb.contains_point?(Vector[-1, 5])).to be false
      expect(aabb.contains_point?(Vector[11, 5])).to be false
    end
  end

  describe "#contains_aabb?" do
    let(:aabb) { Physics::AABB.new(0, 0, 10, 10) }

    it "returns true when other is fully inside" do
      other = Physics::AABB.new(2, 2, 8, 8)
      expect(aabb.contains_aabb?(other)).to be true
    end

    it "returns true when other matches exactly" do
      other = Physics::AABB.new(0, 0, 10, 10)
      expect(aabb.contains_aabb?(other)).to be true
    end

    it "returns false when other extends outside" do
      other = Physics::AABB.new(-1, 0, 10, 10)
      expect(aabb.contains_aabb?(other)).to be false
    end
  end

  describe "#intersects?" do
    let(:aabb) { Physics::AABB.new(0, 0, 10, 10) }

    it "returns true for overlapping boxes" do
      other = Physics::AABB.new(5, 5, 15, 15)
      expect(aabb.intersects?(other)).to be true
    end

    it "returns true for touching boxes" do
      other = Physics::AABB.new(10, 0, 20, 10)
      expect(aabb.intersects?(other)).to be true
    end

    it "returns false for separate boxes" do
      other = Physics::AABB.new(15, 0, 25, 10)
      expect(aabb.intersects?(other)).to be false
    end

    it "returns true for contained box" do
      other = Physics::AABB.new(2, 2, 8, 8)
      expect(aabb.intersects?(other)).to be true
    end
  end

  describe "#intersects_ray?" do
    let(:aabb) { Physics::AABB.new(0, 0, 10, 10) }

    it "returns true for ray passing through" do
      ray = Physics::Ray.new(start_point: Vector[-5, 5], direction: Vector[1, 0], length: 20)
      expect(aabb.intersects_ray?(ray)).to be true
    end

    it "returns false for ray missing" do
      ray = Physics::Ray.new(start_point: Vector[-5, 15], direction: Vector[1, 0], length: 20)
      expect(aabb.intersects_ray?(ray)).to be false
    end

    it "returns false for ray too short" do
      ray = Physics::Ray.new(start_point: Vector[-15, 5], direction: Vector[1, 0], length: 10)
      expect(aabb.intersects_ray?(ray)).to be false
    end

    it "returns true for ray starting inside" do
      ray = Physics::Ray.new(start_point: Vector[5, 5], direction: Vector[1, 0], length: 10)
      expect(aabb.intersects_ray?(ray)).to be true
    end

    it "returns false for ray pointing away" do
      ray = Physics::Ray.new(start_point: Vector[-5, 5], direction: Vector[-1, 0], length: 20)
      expect(aabb.intersects_ray?(ray)).to be false
    end
  end
end
