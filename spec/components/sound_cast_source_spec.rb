RSpec.describe SoundCastSource do
  let(:mock_clip) do
    instance_double(NativeAudio::Clip).tap do |clip|
      allow(clip).to receive(:is_a?).with(NativeAudio::Clip).and_return(true)
    end
  end

  before do
    allow(NativeAudio::Clip).to receive(:new).and_return(mock_clip)
  end

  describe "#start" do
    it "creates a SoundCaster with correct parameters" do
      expect(SoundCaster).to receive(:new)
        .with(beam_count: 8, max_distance: 20, beam_strength: 0.125)
        .and_call_original

      source = SoundCastSource.create(beam_length: 20, beam_count: 8, clip: mock_clip)
      Engine::GameObject.create(
        pos: Vector[5, 0, 10],
        components: [source]
      )
    end
  end

  describe "#update" do
    let(:mock_caster) { instance_double(SoundCaster) }

    before do
      allow(SoundCaster).to receive(:new).and_return(mock_caster)
      allow(mock_caster).to receive(:cast_beams).and_return([])
    end

    it "calls cast_beams with start position and angles" do
      source = SoundCastSource.create(beam_length: 20, beam_count: 8, clip: mock_clip)
      Engine::GameObject.create(
        pos: Vector[5, 0, 10],
        components: [source]
      )

      expect(mock_caster).to receive(:cast_beams)
        .with(start: Vector[5, 10], start_angle: 0, end_angle: 2 * Math::PI)

      source.update(0.016)
    end

    it "adjusts angles based on game object Y rotation" do
      source = SoundCastSource.create(
        beam_length: 20, beam_count: 8, clip: mock_clip,
        start_angle: 0, end_angle: Math::PI / 2
      )
      Engine::GameObject.create(
        pos: Vector[5, 0, 10],
        rotation: Vector[0, 90, 0],
        components: [source]
      )

      # forward after 90° Y rotation points to -X, so atan2(-1, 0) = -π/2
      # we subtract y_rotation, so: 0 - (-π/2) = π/2
      expected_rotation = Math::PI / 2
      expect(mock_caster).to receive(:cast_beams) do |args|
        expect(args[:start]).to eq(Vector[5, 10])
        expect(args[:start_angle]).to be_within(0.01).of(expected_rotation)
        expect(args[:end_angle]).to be_within(0.01).of(Math::PI / 2 + expected_rotation)
      end.and_return([])

      source.update(0.016)
    end
  end
end
