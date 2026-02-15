RSpec.describe "Levels" do
  describe DebugLevel do
    it "loads without error" do
      expect { Map.instance.load_level(DebugLevel) }.not_to raise_error
    end
  end

  describe CryoRoomLevel do
    it "loads without error" do
      expect { Map.instance.load_level(CryoRoomLevel) }.not_to raise_error
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

  describe Airlock do
    it "loads without error" do
      expect { Map.instance.load_level(Airlock) }.not_to raise_error
    end
  end

  describe MedBay do
    it "loads without error" do
      expect { Map.instance.load_level(MedBay) }.not_to raise_error
    end
  end

  describe Stowage do
    it "loads without error" do
      expect { Map.instance.load_level(Stowage) }.not_to raise_error
    end
  end

  describe CargoBayLevel do
    it "loads without error" do
      expect { Map.instance.load_level(CargoBayLevel) }.not_to raise_error
    end
  end
end
