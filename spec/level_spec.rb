RSpec.describe "Levels" do
  describe DebugLevel do
    it "loads without error" do
      expect { Map.instance.load_level(DebugLevel) }.not_to raise_error
    end
  end
end
