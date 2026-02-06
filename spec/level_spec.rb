RSpec.describe "Levels" do
  describe Level01 do
    it "loads without error" do
      expect { Map.instance.load_level(Level01) }.not_to raise_error
    end
  end
end
