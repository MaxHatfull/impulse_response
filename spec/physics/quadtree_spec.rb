RSpec.describe Physics::Quadtree do
  let(:bounds) { Physics::AABB.new(-100, -100, 100, 100) }
  let(:quadtree) { Physics::Quadtree.new(bounds, max_objects: 4, max_depth: 4) }

  def mock_collider(x, y, size = 1)
    collider = double("collider")
    aabb = Physics::AABB.new(x - size, y - size, x + size, y + size)
    allow(collider).to receive(:aabb).and_return(aabb)
    collider
  end

  describe "#insert and #query" do
    it "can insert and query a single collider" do
      collider = mock_collider(0, 0)
      quadtree.insert(collider)

      result = quadtree.query(Physics::AABB.new(-5, -5, 5, 5))
      expect(result).to include(collider)
    end

    it "returns empty array for non-overlapping query" do
      collider = mock_collider(50, 50)
      quadtree.insert(collider)

      result = quadtree.query(Physics::AABB.new(-5, -5, 5, 5))
      expect(result).to be_empty
    end

    it "handles multiple colliders" do
      c1 = mock_collider(0, 0)
      c2 = mock_collider(50, 50)
      c3 = mock_collider(-50, -50)

      quadtree.insert(c1)
      quadtree.insert(c2)
      quadtree.insert(c3)

      result = quadtree.query(Physics::AABB.new(-60, -60, 60, 60))
      expect(result).to contain_exactly(c1, c2, c3)
    end

    it "only returns colliders in queried region" do
      c1 = mock_collider(0, 0)
      c2 = mock_collider(80, 80)

      quadtree.insert(c1)
      quadtree.insert(c2)

      result = quadtree.query(Physics::AABB.new(-10, -10, 10, 10))
      expect(result).to contain_exactly(c1)
    end
  end

  describe "#remove" do
    it "removes a collider from the tree" do
      collider = mock_collider(0, 0)
      quadtree.insert(collider)
      quadtree.remove(collider)

      result = quadtree.query(Physics::AABB.new(-5, -5, 5, 5))
      expect(result).to be_empty
    end
  end

  describe "#update" do
    it "updates collider position" do
      collider = mock_collider(0, 0)
      quadtree.insert(collider)

      # Change the collider's position
      new_aabb = Physics::AABB.new(49, 49, 51, 51)
      allow(collider).to receive(:aabb).and_return(new_aabb)
      quadtree.update(collider)

      # Should not be at old position
      result = quadtree.query(Physics::AABB.new(-5, -5, 5, 5))
      expect(result).to be_empty

      # Should be at new position
      result = quadtree.query(Physics::AABB.new(45, 45, 55, 55))
      expect(result).to include(collider)
    end
  end

  describe "#query_ray" do
    it "returns colliders the ray passes through" do
      c1 = mock_collider(10, 0)
      c2 = mock_collider(0, 50)

      quadtree.insert(c1)
      quadtree.insert(c2)

      ray = Physics::Ray.new(start_point: Vector[-20, 0], direction: Vector[1, 0], length: 50)
      result = quadtree.query_ray(ray)
      expect(result).to include(c1)
      expect(result).not_to include(c2)
    end
  end

  describe "#query_point" do
    it "returns colliders containing the point" do
      c1 = mock_collider(0, 0, 5)
      c2 = mock_collider(50, 50, 5)

      quadtree.insert(c1)
      quadtree.insert(c2)

      result = quadtree.query_point(Vector[2, 2])
      expect(result).to include(c1)
      expect(result).not_to include(c2)
    end
  end

  describe "#clear" do
    it "removes all colliders" do
      5.times { |i| quadtree.insert(mock_collider(i * 10, 0)) }
      quadtree.clear

      result = quadtree.query(bounds)
      expect(result).to be_empty
    end
  end

  describe "splitting behavior" do
    it "splits when max_objects exceeded" do
      # Insert more than max_objects (4) colliders in different quadrants
      5.times { |i| quadtree.insert(mock_collider(i * 5, i * 5)) }

      # Should still be able to query all
      result = quadtree.query(Physics::AABB.new(-10, -10, 30, 30))
      expect(result.size).to eq(5)
    end

    it "keeps straddling objects in parent" do
      # Large collider that would straddle multiple children
      big_collider = mock_collider(0, 0, 60)
      quadtree.insert(big_collider)

      # Add enough small colliders to cause a split
      5.times { |i| quadtree.insert(mock_collider(50 + i, 50 + i, 1)) }

      # Big collider should still be findable
      result = quadtree.query(Physics::AABB.new(-5, -5, 5, 5))
      expect(result).to include(big_collider)
    end
  end
end
