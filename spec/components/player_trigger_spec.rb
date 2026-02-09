RSpec.describe PlayerTrigger do
  let(:callback) { double("callback", call: nil) }
  let(:trigger_go) do
    Engine::GameObject.create(
      pos: Vector[0, 0, 0],
      components: [
        Physics::CircleCollider.create(radius: 2),
        PlayerTrigger.create(on_enter: callback)
      ]
    )
  end
  let(:trigger) { trigger_go.component(PlayerTrigger) }

  def create_player(pos:)
    Engine::GameObject.create(
      pos: Vector[pos[0], 0, pos[1]],
      components: [
        Physics::CircleCollider.create(radius: 0.5, tags: [:player])
      ]
    )
  end

  describe "#update" do
    it "fires callback when player enters trigger zone" do
      create_player(pos: [1, 0])  # Inside trigger (distance 1 < radius 2 + 0.5)

      expect(callback).to receive(:call).once
      trigger.update(0.016)
    end

    it "does not fire callback when player is outside trigger zone" do
      create_player(pos: [10, 0])  # Outside trigger

      expect(callback).not_to receive(:call)
      trigger.update(0.016)
    end

    it "only fires callback once while player remains inside" do
      create_player(pos: [1, 0])

      expect(callback).to receive(:call).once

      trigger.update(0.016)
      trigger.update(0.016)
      trigger.update(0.016)
    end

    it "fires callback again after player leaves and re-enters" do
      player = create_player(pos: [1, 0])

      expect(callback).to receive(:call).twice

      trigger.update(0.016)  # Enter - fires

      player.pos = Vector[10, 0, 0]  # Move outside
      player.component(Physics::CircleCollider).send(:update, 0.016)
      trigger.update(0.016)  # Outside - resets state

      player.pos = Vector[1, 0, 0]  # Move back inside
      player.component(Physics::CircleCollider).send(:update, 0.016)
      trigger.update(0.016)  # Re-enter - fires again
    end

    it "does not fire callback for non-player colliders" do
      Engine::GameObject.create(
        pos: Vector[1, 0, 0],
        components: [
          Physics::CircleCollider.create(radius: 0.5, tags: [:enemy])
        ]
      )

      expect(callback).not_to receive(:call)
      trigger.update(0.016)
    end
  end
end
