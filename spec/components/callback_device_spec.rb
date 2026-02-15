RSpec.describe CallbackDevice do
  describe "#power_on" do
    it "sets powered to true" do
      device = CallbackDevice.new

      device.power_on

      expect(device.powered).to be true
    end

    it "calls the on_power_on callback" do
      callback = double("callback", call: nil)
      device = CallbackDevice.new(on_power_on: callback)

      expect(callback).to receive(:call).once
      device.power_on
    end

    it "does not error when no callback provided" do
      device = CallbackDevice.new

      expect { device.power_on }.not_to raise_error
    end
  end

  describe "#power_off" do
    it "sets powered to false" do
      device = CallbackDevice.new(powered: true)

      device.power_off

      expect(device.powered).to be false
    end

    it "calls the on_power_off callback" do
      callback = double("callback", call: nil)
      device = CallbackDevice.new(powered: true, on_power_off: callback)

      expect(callback).to receive(:call).once
      device.power_off
    end

    it "does not error when no callback provided" do
      device = CallbackDevice.new(powered: true)

      expect { device.power_off }.not_to raise_error
    end
  end

  describe "#powered" do
    it "defaults to false" do
      device = CallbackDevice.new

      expect(device.powered).to be false
    end

    it "can be initialized as true" do
      device = CallbackDevice.new(powered: true)

      expect(device.powered).to be true
    end
  end
end
