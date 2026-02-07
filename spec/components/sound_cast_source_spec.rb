RSpec.describe SoundCastSource do
  describe "#start" do
    let(:mock_caster) { instance_double(SoundCaster) }

    before do
      allow(SoundCaster).to receive(:new).and_return(mock_caster)
      allow(mock_caster).to receive(:cast_beams)
    end

    it "calls cast_beams with correct parameters" do
      expect(mock_caster).to receive(:cast_beams)
        .with(start: Vector[5, 10], length: 20, beam_count: 8)

      Engine::GameObject.create(
        pos: Vector[5, 0, 10],
        components: [SoundCastSource.create(beam_length: 20, beam_count: 8)]
      )
    end
  end
end
