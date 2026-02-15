module Sounds
  BASE_PATH = File.join(__dir__, "assets", "audio")

  module MainMenu
    BASE_PATH = File.join(__dir__, "assets", "audio", "main_menu")

    class << self
      def welcome
        @welcome ||= NativeAudio::Clip.new("#{BASE_PATH}/welcome.wav")
      end

      def start_game
        @start_game ||= NativeAudio::Clip.new("#{BASE_PATH}/start_game.wav")
      end

      def exit_game
        @exit_game ||= NativeAudio::Clip.new("#{BASE_PATH}/exit.wav")
      end

      def music
        @music ||= NativeAudio::Clip.new(File.join(__dir__, "assets", "audio", "menu", "music.wav"))
      end
    end
  end

  class << self
    def tap
      @tap ||= NativeAudio::Clip.new("#{BASE_PATH}/clicks/DullClick2.wav")
    end

    def door_ambient
      @door_ambient ||= NativeAudio::Clip.new("#{BASE_PATH}/door/ambient.wav")
    end

    def door_locked
      @door_locked ||= NativeAudio::Clip.new("#{BASE_PATH}/door/Door locked.wav")
    end

    def door_requires_power
      @door_requires_power ||= NativeAudio::Clip.new("#{BASE_PATH}/door/door_requires_power.wav")
    end

    def terminal
      @terminal ||= NativeAudio::Clip.new("#{BASE_PATH}/basic_audio/computerNoise_000.wav")
    end

    def debug_1
      @debug_1 ||= NativeAudio::Clip.new(File.join(__dir__, "assets", "sci_fi_audio", "1 Sci Fi Sound.wav"))
    end

    def debug_3
      @debug_3 ||= NativeAudio::Clip.new(File.join(__dir__, "assets", "sci_fi_audio", "3 Sci Fi Sound.wav"))
    end

    def debug_5
      @debug_5 ||= NativeAudio::Clip.new(File.join(__dir__, "assets", "sci_fi_audio", "5 Sci Fi Sound.wav"))
    end

    def interacter_enter
      @interacter_enter ||= NativeAudio::Clip.new("#{BASE_PATH}/clicks/SharpClick2.wav")
    end

  end

  module Terminal
    BASE_PATH = File.join(__dir__, "assets", "audio", "terminal")

    class << self
      def insufficient_power
        @insufficient_power ||= NativeAudio::Clip.new("#{BASE_PATH}/insufficient_power.wav")
      end
    end
  end

  module CircuitPanel
    BASE_PATH = File.join(__dir__, "assets", "audio", "circuit_panel")

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

      def welcome_power_3
        @welcome_power_3 ||= NativeAudio::Clip.new("#{BASE_PATH}/circuit_panel_total_power_3.wav")
      end

      def welcome_power_4
        @welcome_power_4 ||= NativeAudio::Clip.new("#{BASE_PATH}/circuit_panel_total_power_4.wav")
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

  module Level0
    BASE_PATH = File.join(__dir__, "assets", "audio", "level_0")

    class << self
      def corridor_trigger
        @corridor_trigger ||= NativeAudio::Clip.new("#{BASE_PATH}/Level 0 Corridor trigger.wav")
      end
    end
  end

  module Level1
    module Door
      BASE_PATH = File.join(__dir__, "assets", "audio", "level_1", "door")

      class << self
        def corridor_trigger
          @corridor_trigger ||= NativeAudio::Clip.new("#{BASE_PATH}/corridor.wav")
        end

        def medbay
          @medbay ||= NativeAudio::Clip.new("#{BASE_PATH}/medbay.wav")
        end

        def stowage
          @stowage ||= NativeAudio::Clip.new("#{BASE_PATH}/stowage.wav")
        end

        def airlock
          @airlock ||= NativeAudio::Clip.new("#{BASE_PATH}/airlock.wav")
        end

        def quarantine_active
          @quarantine_active ||= NativeAudio::Clip.new("#{BASE_PATH}/quarantine_active.wav")
        end

        def level_2
          @level_2 ||= NativeAudio::Clip.new("#{BASE_PATH}/level_2.wav")
        end
      end
    end

    module Corridor
      BASE_PATH = File.join(__dir__, "assets", "audio", "level_1", "corridor")

      class << self
        def entry_trigger
          @entry_trigger ||= NativeAudio::Clip.new("#{BASE_PATH}/entry_trigger.wav")
        end
      end
    end

    module Terminal
      BASE_PATH = File.join(__dir__, "assets", "audio", "level_1", "terminal")

      class << self
        def welcome
          @welcome ||= NativeAudio::Clip.new("#{BASE_PATH}/welcome.wav")
        end

        def airlock_status
          @airlock_status ||= NativeAudio::Clip.new("#{BASE_PATH}/airlock_status.wav")
        end

        def airlock_status_result
          @airlock_status_result ||= NativeAudio::Clip.new("#{BASE_PATH}/airlock_status_result.wav")
        end

        def crew_status
          @crew_status ||= NativeAudio::Clip.new("#{BASE_PATH}/crew_status.wav")
        end

        def crew_status_result_terminal
          @crew_status_result_terminal ||= NativeAudio::Clip.new("#{BASE_PATH}/crew_status_result_terminal.wav")
        end

        def crew_status_result_player
          @crew_status_result_player ||= NativeAudio::Clip.new("#{BASE_PATH}/crew_status_result_player.wav")
        end

        def eva_suit_status
          @eva_suit_status ||= NativeAudio::Clip.new("#{BASE_PATH}/eva_suit_status.wav")
        end

        def eva_suit_status_result
          @eva_suit_status_result ||= NativeAudio::Clip.new("#{BASE_PATH}/eva_suit_status_result.wav")
        end

        def depressurize
          @depressurize ||= NativeAudio::Clip.new("#{BASE_PATH}/depressurize.wav")
        end

        def depressurize_result
          @depressurize_result ||= NativeAudio::Clip.new("#{BASE_PATH}/depressurize_result.wav")
        end

        def outer_door
          @outer_door ||= NativeAudio::Clip.new("#{BASE_PATH}/outer_door.wav")
        end

        def outer_door_result
          @outer_door_result ||= NativeAudio::Clip.new("#{BASE_PATH}/outer_door_result.wav")
        end

        def inner_door
          @inner_door ||= NativeAudio::Clip.new("#{BASE_PATH}/inner_door.wav")
        end

        def inner_door_result_terminal
          @inner_door_result_terminal ||= NativeAudio::Clip.new("#{BASE_PATH}/inner_door_result_terminal.wav")
        end

        def inner_door_result_player
          @inner_door_result_player ||= NativeAudio::Clip.new("#{BASE_PATH}/inner_door_result_player.wav")
        end
      end
    end
  end

  module CryoRoom
    module Door
      BASE_PATH = File.join(__dir__, "assets", "audio", "cryo_room", "door")

      class << self
        def corridor
          @corridor ||= NativeAudio::Clip.new("#{BASE_PATH}/Corridor.wav")
        end
      end
    end

    module Terminal
      BASE_PATH = File.join(__dir__, "assets", "audio", "cryo_room", "terminal")

      class << self
        def welcome
          @welcome ||= NativeAudio::Clip.new("#{BASE_PATH}/Health Check complete 2.wav")
        end

        def navigation_tutorial
          @navigation_tutorial ||= NativeAudio::Clip.new("#{BASE_PATH}/Terminal navigation tutorial.wav")
        end

        def ship_status
          @ship_status ||= NativeAudio::Clip.new("#{BASE_PATH}/Ship Status.wav")
        end

        def ship_status_result_terminal
          @ship_status_result_terminal ||= NativeAudio::Clip.new("#{BASE_PATH}/Ship Status Result - Terminal only.wav")
        end

        def ship_status_result_player
          @ship_status_result_player ||= NativeAudio::Clip.new("#{BASE_PATH}/Ship Status Result - Quinn only.wav")
        end

        def crew_status
          @crew_status ||= NativeAudio::Clip.new("#{BASE_PATH}/Crew Status.wav")
        end

        def crew_status_result_terminal
          @crew_status_result_terminal ||= NativeAudio::Clip.new("#{BASE_PATH}/Crew Status Result - Terminal only.wav")
        end

        def crew_status_result_player
          @crew_status_result_player ||= NativeAudio::Clip.new("#{BASE_PATH}/Crew Status Result - Quinn only.wav")
        end

        def cryopod_status
          @cryopod_status ||= NativeAudio::Clip.new("#{BASE_PATH}/CryoPod Status.wav")
        end

        def cryopod_status_result
          @cryopod_status_result ||= NativeAudio::Clip.new("#{BASE_PATH}/Cryopod status Result.wav")
        end

        def emergency_override
          @emergency_override ||= NativeAudio::Clip.new("#{BASE_PATH}/Emergency Cryopod override.wav")
        end

        def emergency_override_result_terminal
          @emergency_override_result_terminal ||= NativeAudio::Clip.new("#{BASE_PATH}/Emergency Cryopod Override result - Terminal only.wav")
        end

        def emergency_override_result_player
          @emergency_override_result_player ||= NativeAudio::Clip.new("#{BASE_PATH}/Emergency Cryopod Override result - Quinn only.wav")
        end
      end
    end

    module CircuitPanel
      BASE_PATH = File.join(__dir__, "assets", "audio", "cryo_room", "circuit_panel")

      class << self
        def main_door
          @main_door ||= NativeAudio::Clip.new("#{BASE_PATH}/main_door.wav")
        end

        def terminal
          @terminal ||= NativeAudio::Clip.new("#{BASE_PATH}/terminal.wav")
        end

        def cryo_pods
          @cryo_pods ||= NativeAudio::Clip.new("#{BASE_PATH}/cryo_pods.wav")
        end
      end
    end

    module Tutorial
      BASE_PATH = File.join(__dir__, "assets", "audio", "cryo_room", "tutorial")

      class << self
        def awakening_terminal
          @awakening_terminal ||= NativeAudio::Clip.new("#{BASE_PATH}/Awakening - Terminal only.wav")
        end

        def awakening_player
          @awakening_player ||= NativeAudio::Clip.new("#{BASE_PATH}/Awakening - Quinn only.wav")
        end

        def health_check_exercise_2
          @health_check_exercise_2 ||= NativeAudio::Clip.new("#{BASE_PATH}/Health Check Exercise 2.wav")
        end

        def health_check_exercise_3_and_4
          @health_check_exercise_3_and_4 ||= NativeAudio::Clip.new("#{BASE_PATH}/Health Check Exercise 3 and 4.wav")
        end

        def health_check_complete_1
          @health_check_complete_1 ||= NativeAudio::Clip.new("#{BASE_PATH}/Health Check Complete 1.wav")
        end
      end
    end
  end

  module MedBay
    module Terminal
      BASE_PATH = File.join(__dir__, "assets", "audio", "medbay", "terminal")

      class << self
        def welcome
          @welcome ||= NativeAudio::Clip.new("#{BASE_PATH}/welcome.wav")
        end

        def diagnostic_kerrick
          @diagnostic_kerrick ||= NativeAudio::Clip.new("#{BASE_PATH}/diagnostic_kerrick.wav")
        end

        def diagnostic_kerrick_unpowered
          @diagnostic_kerrick_unpowered ||= NativeAudio::Clip.new("#{BASE_PATH}/diagnostic_kerrick_unpowered.wav")
        end

        def diagnostic_kerrick_result_terminal
          @diagnostic_kerrick_result_terminal ||= NativeAudio::Clip.new("#{BASE_PATH}/diagnostic_kerrick_result_terminal.wav")
        end

        def diagnostic_kerrick_result_quinn
          @diagnostic_kerrick_result_quinn ||= NativeAudio::Clip.new("#{BASE_PATH}/diagnostic_kerrick_result_quinn.wav")
        end

        def diagnostic_quinn
          @diagnostic_quinn ||= NativeAudio::Clip.new("#{BASE_PATH}/diagnostic_quinn.wav")
        end

        def diagnostic_quinn_unpowered
          @diagnostic_quinn_unpowered ||= NativeAudio::Clip.new("#{BASE_PATH}/diagnostic_quinn_unpowered.wav")
        end

        def diagnostic_quinn_result_terminal
          @diagnostic_quinn_result_terminal ||= NativeAudio::Clip.new("#{BASE_PATH}/diagnostic_quinn_result_terminal.wav")
        end

        def diagnostic_quinn_result_quinn
          @diagnostic_quinn_result_quinn ||= NativeAudio::Clip.new("#{BASE_PATH}/diagnostic_quinn_result_quinn.wav")
        end

        def quarantine_status
          @quarantine_status ||= NativeAudio::Clip.new("#{BASE_PATH}/quarantine_status.wav")
        end

        def quarantine_status_result_terminal
          @quarantine_status_result_terminal ||= NativeAudio::Clip.new("#{BASE_PATH}/quarantine_status_result_terminal.wav")
        end

        def quarantine_status_result_quinn
          @quarantine_status_result_quinn ||= NativeAudio::Clip.new("#{BASE_PATH}/quarantine_status_result_quinn.wav")
        end

        def cryo_sleep
          @cryo_sleep ||= NativeAudio::Clip.new("#{BASE_PATH}/cryo_sleep.wav")
        end

        def cryo_sleep_result_terminal
          @cryo_sleep_result_terminal ||= NativeAudio::Clip.new("#{BASE_PATH}/cryo_sleep_result_terminal.wav")
        end

        def cryo_sleep_result_quinn
          @cryo_sleep_result_quinn ||= NativeAudio::Clip.new("#{BASE_PATH}/cryo_sleep_result_quinn.wav")
        end
      end
    end
  end

  module Airlock
    BASE_PATH = File.join(__dir__, "assets", "audio", "airlock")

    class << self
      def find_kerrick_quinn
        @find_kerrick_quinn ||= NativeAudio::Clip.new("#{BASE_PATH}/find_kerrick_quinn.wav")
      end

      def find_kerrick_terminal
        @find_kerrick_terminal ||= NativeAudio::Clip.new("#{BASE_PATH}/find_kerrick_terminal.wav")
      end
    end
  end

  module StowageRoom
    module CircuitPanel
      BASE_PATH = File.join(__dir__, "assets", "audio", "stowage_room", "circuit_panel")

      class << self
        def airlock_interior_door
          @airlock_interior_door ||= NativeAudio::Clip.new("#{BASE_PATH}/airlock_interior_door.wav")
        end

        def medbay_diagnostic_pod
          @medbay_diagnostic_pod ||= NativeAudio::Clip.new("#{BASE_PATH}/medbay_diagnostic_pod.wav")
        end

        def medbay_terminal
          @medbay_terminal ||= NativeAudio::Clip.new("#{BASE_PATH}/medbay_terminal.wav")
        end

        def medbay_door
          @medbay_door ||= NativeAudio::Clip.new("#{BASE_PATH}/medbay_door.wav")
        end

        def stowage_door
          @stowage_door ||= NativeAudio::Clip.new("#{BASE_PATH}/stowage_door.wav")
        end

        def door_to_level_2
          @door_to_level_2 ||= NativeAudio::Clip.new("#{BASE_PATH}/door_to_level_2.wav")
        end
      end
    end
  end
end
