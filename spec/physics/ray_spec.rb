RSpec.describe Physics::Ray do
  describe "#direction" do
    it "normalizes the direction" do
      ray = Physics::Ray.new(start_point: Vector[0, 0], direction: Vector[3, 4], length: 10)

      expect(ray.direction[0]).to be_within(0.001).of(0.6)
      expect(ray.direction[1]).to be_within(0.001).of(0.8)
    end
  end
end
