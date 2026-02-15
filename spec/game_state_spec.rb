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

    it "handles nested hashes" do
      game_state.update(level_1: { medbay_door: true })
      game_state.update(level_1: { airlock_door: false })

      expect(game_state.get(:level_1)).to eq({ medbay_door: true, airlock_door: false })
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
  end

  describe "#reset" do
    it "clears all state" do
      game_state.update(foo: "bar")
      game_state.reset

      expect(game_state.get(:foo)).to be_nil
    end
  end
end
