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
        .with(beam_count: 8, max_distance: 20)
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

    it "calls cast_beams with start position" do
      source = SoundCastSource.create(beam_length: 20, beam_count: 8, clip: mock_clip)
      Engine::GameObject.create(
        pos: Vector[5, 0, 10],
        components: [source]
      )

      expect(mock_caster).to receive(:cast_beams)
        .with(start: Vector[5, 10])

      source.update(0.016)
    end
  end
end
