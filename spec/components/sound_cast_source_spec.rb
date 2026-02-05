require "spec_helper"
require_relative "../../impulse_response/loader"

RSpec.describe SoundCastSource do
  before { Physics.clear_colliders }

  describe "#update" do
    it "casts a beam from the game object position" do
      source = SoundCastSource.create(beam_length: 20)
      Engine::GameObject.create(
        pos: Vector[5, 0, 10],
        components: [source]
      )

      expect(SoundCaster.instance).to receive(:cast_beam).with(
        start: Vector[5, 10],
        direction: anything,
        length: 20
      )

      source.update(0.016)
    end

    it "casts in the forward direction of the game object" do
      source = SoundCastSource.create(beam_length: 20)
      Engine::GameObject.create(
        pos: Vector[0, 0, 0],
        components: [source]
      )

      expect(SoundCaster.instance).to receive(:cast_beam).with(
        start: Vector[0, 0],
        direction: Vector[0, 1],
        length: 20
      )

      source.update(0.016)
    end

    it "respects game object rotation" do
      source = SoundCastSource.create(beam_length: 20)
      game_object = Engine::GameObject.create(
        pos: Vector[0, 0, 0],
        rotation: Engine::Quaternion.from_euler(Vector[0, 90, 0]),
        components: [source]
      )

      expect(SoundCaster.instance).to receive(:cast_beam) do |args|
        # Forward should now be -X direction (mapped to 2D: x=-1, z=0)
        expect(args[:direction][0]).to be_within(0.01).of(-1)
        expect(args[:direction][1]).to be_within(0.01).of(0)
      end

      source.update(0.016)
    end
  end
end
