RSpec.describe AudioQueue do
  let(:output_source) { double("output_source", set_clip: nil, play: nil) }
  let(:clip) { double("clip", duration: 1.0) }
  let(:clip2) { double("clip2", duration: 0.5) }

  describe "#queue" do
    it "plays the first clip immediately" do
      queue = AudioQueue.new(output_source)

      expect(output_source).to receive(:set_clip).with(clip)
      expect(output_source).to receive(:play)

      queue.queue(clip)
    end

    it "filters out nil clips" do
      queue = AudioQueue.new(output_source)

      expect(output_source).to receive(:set_clip).with(clip)
      expect(output_source).to receive(:play)

      queue.queue(nil, clip, nil)
    end

    it "does nothing when all clips are nil" do
      queue = AudioQueue.new(output_source)

      expect(output_source).not_to receive(:set_clip)
      expect(output_source).not_to receive(:play)

      queue.queue(nil, nil)
    end
  end

  describe "#playing?" do
    it "returns false before any clips are queued" do
      queue = AudioQueue.new(output_source)

      expect(queue.playing?).to be false
    end

    it "returns true while a clip is playing" do
      queue = AudioQueue.new(output_source)
      queue.queue(clip)

      expect(queue.playing?).to be true
    end

    it "returns false after clip duration has passed" do
      queue = AudioQueue.new(output_source)

      allow(Time).to receive(:now).and_return(Time.at(0))
      queue.queue(clip)

      allow(Time).to receive(:now).and_return(Time.at(1.1))
      expect(queue.playing?).to be false
    end
  end

  describe "#update" do
    it "plays the next clip when current clip finishes" do
      queue = AudioQueue.new(output_source)

      allow(Time).to receive(:now).and_return(Time.at(0))
      queue.queue(clip, clip2)

      allow(Time).to receive(:now).and_return(Time.at(1.1))

      expect(output_source).to receive(:set_clip).with(clip2)
      expect(output_source).to receive(:play)

      queue.update
    end

    it "does nothing while a clip is still playing" do
      queue = AudioQueue.new(output_source)

      allow(Time).to receive(:now).and_return(Time.at(0))
      queue.queue(clip, clip2)

      allow(Time).to receive(:now).and_return(Time.at(0.5))

      expect(output_source).not_to receive(:set_clip)

      queue.update
    end

    it "does nothing when queue is empty" do
      queue = AudioQueue.new(output_source)

      allow(Time).to receive(:now).and_return(Time.at(0))
      queue.queue(clip)

      allow(Time).to receive(:now).and_return(Time.at(1.1))

      expect(output_source).not_to receive(:set_clip)

      queue.update
    end
  end

  describe "#interrupt" do
    it "clears the queue" do
      queue = AudioQueue.new(output_source)

      allow(Time).to receive(:now).and_return(Time.at(0))
      queue.queue(clip, clip2)
      queue.interrupt

      allow(Time).to receive(:now).and_return(Time.at(1.1))

      expect(output_source).not_to receive(:set_clip)

      queue.update
    end

    it "stops tracking current clip" do
      queue = AudioQueue.new(output_source)

      allow(Time).to receive(:now).and_return(Time.at(0))
      queue.queue(clip)
      queue.interrupt

      expect(queue.playing?).to be false
    end
  end
end
