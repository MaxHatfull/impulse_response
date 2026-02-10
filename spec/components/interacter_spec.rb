RSpec.describe Interacter do
  let(:callback) { double("callback", call: nil) }
  let(:interacter_go) do
    Engine::GameObject.create(
      pos: Vector[0, 0, 0],
      components: [
        Physics::CircleCollider.create(radius: 2),
        Interacter.create(on_interact: callback)
      ]
    )
  end
  let(:interacter) { interacter_go.component(Interacter) }

  def create_player(pos:)
    Engine::GameObject.create(
      pos: Vector[pos[0], 0, pos[1]],
      components: [
        Physics::CircleCollider.create(radius: 0.5, tags: [:player])
      ]
    )
  end

  describe "#update" do
    it "fires callback when player is inside and presses E" do
      create_player(pos: [1, 0])
      allow(Engine::Input).to receive(:key_down?).with(Engine::Input::KEY_E).and_return(true)

      expect(callback).to receive(:call).once
      interacter.update(0.016)
    end

    it "does not fire callback when player is inside but E not pressed" do
      create_player(pos: [1, 0])
      allow(Engine::Input).to receive(:key_down?).with(Engine::Input::KEY_E).and_return(false)

      expect(callback).not_to receive(:call)
      interacter.update(0.016)
    end

    it "does not fire callback when E pressed but player is outside" do
      create_player(pos: [10, 0])
      allow(Engine::Input).to receive(:key_down?).with(Engine::Input::KEY_E).and_return(true)

      expect(callback).not_to receive(:call)
      interacter.update(0.016)
    end

    it "fires callback each time E is pressed while inside" do
      create_player(pos: [1, 0])

      expect(callback).to receive(:call).twice

      allow(Engine::Input).to receive(:key_down?).with(Engine::Input::KEY_E).and_return(true)
      interacter.update(0.016)

      allow(Engine::Input).to receive(:key_down?).with(Engine::Input::KEY_E).and_return(false)
      interacter.update(0.016)

      allow(Engine::Input).to receive(:key_down?).with(Engine::Input::KEY_E).and_return(true)
      interacter.update(0.016)
    end

    it "does not fire callback for non-player colliders" do
      Engine::GameObject.create(
        pos: Vector[1, 0, 0],
        components: [
          Physics::CircleCollider.create(radius: 0.5, tags: [:enemy])
        ]
      )
      allow(Engine::Input).to receive(:key_down?).with(Engine::Input::KEY_E).and_return(true)

      expect(callback).not_to receive(:call)
      interacter.update(0.016)
    end
  end
end
