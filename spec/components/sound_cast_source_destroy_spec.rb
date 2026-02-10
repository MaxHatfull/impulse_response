RSpec.describe SoundCastSource, "#destroy" do
  let(:mock_clip) { instance_double(NativeAudio::Clip) }
  let(:mock_audio_source) do
    instance_double(NativeAudio::AudioSource,
      play: nil, stop: nil, set_pos: nil, set_volume: nil,
      set_looping: nil, set_reverb: nil
    )
  end

  before do
    allow(NativeAudio::Clip).to receive(:new).and_return(mock_clip)
    allow(NativeAudio::AudioSource).to receive(:new).and_return(mock_audio_source)
  end

  it "stops audio on all listeners when destroyed" do
    # Create a sound source
    source_go = Engine::GameObject.create(
      pos: Vector[0, 0, 0],
      components: [
        SoundCastSource.create(beam_length: 20, beam_count: 8)
      ]
    )
    source = source_go.component(SoundCastSource)

    # Create a listener
    listener_go = Engine::GameObject.create(
      pos: Vector[5, 0, 0],
      components: [
        Physics::CircleCollider.create(radius: 2, tags: [:listener]),
        SoundListener.create
      ]
    )
    listener = listener_go.component(SoundListener)

    # Simulate a sound hit to create a SoundPlayer
    source.update(0.016)

    # Verify audio stop is called when source is destroyed
    expect(mock_audio_source).to receive(:stop).twice  # left and right channels

    source.destroy
  end

  it "handles destruction when no listeners exist" do
    source_go = Engine::GameObject.create(
      pos: Vector[0, 0, 0],
      components: [
        SoundCastSource.create(beam_length: 20, beam_count: 8)
      ]
    )
    source = source_go.component(SoundCastSource)

    expect { source.destroy }.not_to raise_error
  end

  it "handles destruction when listener has no sound player for this source" do
    source_go = Engine::GameObject.create(
      pos: Vector[0, 0, 0],
      components: [
        SoundCastSource.create(beam_length: 20, beam_count: 8)
      ]
    )
    source = source_go.component(SoundCastSource)

    # Create a listener but don't trigger any sound hits
    Engine::GameObject.create(
      pos: Vector[100, 0, 0],  # Far away, won't receive hits
      components: [
        Physics::CircleCollider.create(radius: 2, tags: [:listener]),
        SoundListener.create
      ]
    )

    expect { source.destroy }.not_to raise_error
  end
end
