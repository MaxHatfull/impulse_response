class AudioQueue
  def initialize(output_source)
    @output_source = output_source
    @queue = []
    @clip_end_time = nil
  end

  def queue(*clips)
    @queue = clips.compact
    process_queue
  end

  def update
    process_queue unless playing?
  end

  def playing?
    return false unless @clip_end_time

    Time.now < @clip_end_time
  end

  def interrupt
    @queue = []
    @clip_end_time = nil
  end

  private

  def process_queue
    return if @queue.empty?

    clip = @queue.shift
    play_clip(clip)
  end

  def play_clip(clip)
    return unless clip

    @output_source.set_clip(clip)
    @output_source.play
    @clip_end_time = Time.now + clip.duration
  end
end
