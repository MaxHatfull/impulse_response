require "spec_helper"
require_relative "../impulse_response/loader"

RSpec.describe Raycast do
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
end
