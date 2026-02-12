module Sounds
  BASE_PATH = "impulse_response/assets/audio"

  class << self
    def tap
      @tap ||= NativeAudio::Clip.new("#{BASE_PATH}/clicks/DullClick2.wav")
    end

    def door_ambient
      @door_ambient ||= NativeAudio::Clip.new("#{BASE_PATH}/door/ambient.wav")
    end

    def door_locked
      @door_locked ||= NativeAudio::Clip.new("#{BASE_PATH}/door/locked.wav")
    end

    def door_requires_power
      @door_requires_power ||= NativeAudio::Clip.new("#{BASE_PATH}/door/door_requires_power.wav")
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

  module CircuitPanel
    BASE_PATH = "impulse_response/assets/audio/circuit_panel"

    class << self
      def ambient
        @ambient ||= NativeAudio::Clip.new("#{BASE_PATH}/ambient.wav")
      end

      def power_on
        @power_on ||= NativeAudio::Clip.new("#{BASE_PATH}/power_on.wav")
      end

      def power_off
        @power_off ||= NativeAudio::Clip.new("#{BASE_PATH}/power_off.wav")
      end

      def welcome
        @welcome ||= NativeAudio::Clip.new("#{BASE_PATH}/circuit_panel_total_power_1.wav")
      end

      def insufficient_power
        @insufficient_power ||= NativeAudio::Clip.new("#{BASE_PATH}/insufficient_power.wav")
      end

      def powered
        @powered ||= NativeAudio::Clip.new("#{BASE_PATH}/powered.wav")
      end

      def unpowered
        @unpowered ||= NativeAudio::Clip.new("#{BASE_PATH}/unpowered.wav")
      end
    end
  end
end
