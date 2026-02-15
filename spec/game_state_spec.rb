RSpec.describe GameState do
  let(:game_state) { GameState.instance }

  before do
    game_state.reset
  end

  describe ".instance" do
    it "returns the same instance" do
      expect(GameState.instance).to be GameState.instance
    end
  end

  describe "#update" do
    it "stores new state" do
      game_state.update(door_powered: true)

      expect(game_state.get(:door_powered)).to be true
    end

    it "merges with existing state" do
      game_state.update(door_powered: true)
      game_state.update(terminal_powered: false)

      expect(game_state.get(:door_powered)).to be true
      expect(game_state.get(:terminal_powered)).to be false
    end

    it "overrides existing keys" do
      game_state.update(door_powered: true)
      game_state.update(door_powered: false)

      expect(game_state.get(:door_powered)).to be false
    end
  end

  describe "#get" do
    it "returns nil for unknown keys" do
      expect(game_state.get(:unknown)).to be_nil
    end

    it "returns the stored value" do
      game_state.update(foo: "bar")

      expect(game_state.get(:foo)).to eq "bar"
    end

    it "returns default values for circuit panel devices" do
      expect(game_state.get(:airlock_interior_door_powered)).to be true
      expect(game_state.get(:medbay_diagnostic_pod_powered)).to be false
      expect(game_state.get(:medbay_terminal_powered)).to be false
      expect(game_state.get(:medbay_door_powered)).to be true
      expect(game_state.get(:door_to_level_2_powered)).to be false
    end
  end

  describe "#reset" do
    it "restores to defaults" do
      game_state.update(foo: "bar", airlock_interior_door_powered: false)
      game_state.reset

      expect(game_state.get(:foo)).to be_nil
      expect(game_state.get(:airlock_interior_door_powered)).to be true
    end
  end

  describe "#key?" do
    it "returns false for unknown keys" do
      expect(game_state.key?(:unknown)).to be false
    end

    it "returns true for existing keys" do
      game_state.update(foo: "bar")

      expect(game_state.key?(:foo)).to be true
    end

    it "returns true even if value is nil" do
      game_state.update(foo: nil)

      expect(game_state.key?(:foo)).to be true
    end

    it "returns true even if value is false" do
      game_state.update(foo: false)

      expect(game_state.key?(:foo)).to be true
    end
  end
end
