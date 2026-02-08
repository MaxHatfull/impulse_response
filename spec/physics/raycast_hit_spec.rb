RSpec.describe Physics::RaycastHit do
  let(:ray) { Physics::Ray.new(start_point: Vector[0, 0], direction: Vector[1, 0], length: 10) }
  let(:collider) { double("collider") }

  describe "attributes" do
    it "exposes ray, entry_point, exit_point, entry_normal, exit_normal, and collider" do
      hit = Physics::RaycastHit.new(
        ray: ray,
        entry_point: Vector[2, 0],
        exit_point: Vector[4, 0],
        entry_normal: Vector[-1, 0],
        exit_normal: Vector[1, 0],
        collider: collider
      )

      expect(hit.ray).to eq(ray)
      expect(hit.entry_point).to eq(Vector[2, 0])
      expect(hit.exit_point).to eq(Vector[4, 0])
      expect(hit.entry_normal).to eq(Vector[-1, 0])
      expect(hit.exit_normal).to eq(Vector[1, 0])
      expect(hit.collider).to eq(collider)
    end
  end

  describe "#entry_normal" do
    it "normalizes the entry_normal when provided" do
      hit = Physics::RaycastHit.new(
        ray: ray,
        entry_point: Vector[2, 0],
        exit_point: Vector[4, 0],
        entry_normal: Vector[3, 4],
        exit_normal: Vector[1, 0],
        collider: collider
      )

      expect(hit.entry_normal[0]).to be_within(0.001).of(0.6)
      expect(hit.entry_normal[1]).to be_within(0.001).of(0.8)
    end

    it "is nil when ray starts inside collider" do
      hit = Physics::RaycastHit.new(
        ray: ray,
        entry_point: Vector[0, 0],
        exit_point: Vector[4, 0],
        entry_normal: nil,
        exit_normal: Vector[1, 0],
        collider: collider
      )

      expect(hit.entry_normal).to be_nil
    end
  end

  describe "#exit_normal" do
    it "normalizes the exit_normal when provided" do
      hit = Physics::RaycastHit.new(
        ray: ray,
        entry_point: Vector[2, 0],
        exit_point: Vector[4, 0],
        entry_normal: Vector[-1, 0],
        exit_normal: Vector[3, 4],
        collider: collider
      )

      expect(hit.exit_normal[0]).to be_within(0.001).of(0.6)
      expect(hit.exit_normal[1]).to be_within(0.001).of(0.8)
    end

    it "is nil when ray ends inside collider" do
      hit = Physics::RaycastHit.new(
        ray: ray,
        entry_point: Vector[2, 0],
        exit_point: Vector[10, 0],
        entry_normal: Vector[-1, 0],
        exit_normal: nil,
        collider: collider
      )

      expect(hit.exit_normal).to be_nil
    end
  end

  describe "#entry_distance" do
    it "calculates distance from ray start to entry point" do
      hit = Physics::RaycastHit.new(
        ray: ray,
        entry_point: Vector[3, 0],
        exit_point: Vector[5, 0],
        entry_normal: Vector[-1, 0],
        exit_normal: Vector[1, 0],
        collider: collider
      )

      expect(hit.entry_distance).to be_within(0.001).of(3)
    end
  end

  describe "#exit_distance" do
    it "calculates distance from ray start to exit point" do
      hit = Physics::RaycastHit.new(
        ray: ray,
        entry_point: Vector[3, 0],
        exit_point: Vector[7, 0],
        entry_normal: Vector[-1, 0],
        exit_normal: Vector[1, 0],
        collider: collider
      )

      expect(hit.exit_distance).to be_within(0.001).of(7)
    end
  end
end
