RSpec.describe "Levels" do
  describe DebugLevel do
    it "loads without error" do
      expect { Map.instance.load_level(DebugLevel) }.not_to raise_error
    end
  end

  describe IntroductionLevel do
    it "loads without error" do
      expect { Map.instance.load_level(IntroductionLevel) }.not_to raise_error
    end
  end

  describe Level0Corridor do
    it "loads without error" do
      expect { Map.instance.load_level(Level0Corridor) }.not_to raise_error
    end
  end

  describe Level1Corridor do
    it "loads without error" do
      expect { Map.instance.load_level(Level1Corridor) }.not_to raise_error
    end
  end

  describe CargoBayLevel do
    it "loads without error" do
      expect { Map.instance.load_level(CargoBayLevel) }.not_to raise_error
    end
  end
end
