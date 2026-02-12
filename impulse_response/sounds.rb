module Sounds
  BASE_PATH = "impulse_response/assets/audio"

  class << self
    def tap
      @tap ||= NativeAudio::Clip.new("#{BASE_PATH}/clicks/DullClick2.wav")
    end

    def door
      @door ||= NativeAudio::Clip.new("impulse_response/assets/sci_fi_audio/2 Sci Fi Sound.wav")
    end

    def terminal
      @terminal ||= NativeAudio::Clip.new("#{BASE_PATH}/basic_audio/computerNoise_000.wav")
    end

    def debug_1
      @debug_1 ||= NativeAudio::Clip.new("impulse_response/assets/sci_fi_audio/1 Sci Fi Sound.wav")
    end

    def debug_3
      @debug_3 ||= NativeAudio::Clip.new("impulse_response/assets/sci_fi_audio/3 Sci Fi Sound.wav")
    end

    def debug_5
      @debug_5 ||= NativeAudio::Clip.new("impulse_response/assets/sci_fi_audio/5 Sci Fi Sound.wav")
    end

    def interacter_enter
      @interacter_enter ||= NativeAudio::Clip.new("#{BASE_PATH}/clicks/SharpClick2.wav")
    end
  end
end
