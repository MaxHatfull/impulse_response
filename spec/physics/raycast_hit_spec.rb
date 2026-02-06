RSpec.describe Physics::RaycastHit do
  describe "#normal" do
    it "normalizes the normal" do
      hit = Physics::RaycastHit.new(
        collider: nil,
        point: Vector[0, 0],
        distance: 5,
        normal: Vector[3, 4]
      )

      expect(hit.normal[0]).to be_within(0.001).of(0.6)
      expect(hit.normal[1]).to be_within(0.001).of(0.8)
    end
  end
end
