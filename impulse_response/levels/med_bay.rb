class MedBay < Level
  def bounds
    Physics::AABB.new(-21, -24, 21, 5)
  end

  def skybox_color
    Vector[0.2, 0.6, 0.2]  # Dark green
  end

  def create
    puts "loading medbay"

    # Large rectangular room (30m wide x 18m long)
    wall(x: -15, z: -9, width: 1, length: 18)     # left wall
    wall(x: 15, z: -9, width: 1, length: 18)      # right wall
    wall(x: 0, z: 0, width: 30, length: 1)        # back wall (entrance)
    wall(x: 0, z: -18, width: 30, length: 1)      # front wall

    # Door back to Level 1 corridor (behind player spawn)
    door(x: -13, z: -1, level_class: Level1Corridor, level_options: { from: :medbay }, trigger_clip: Sounds::Level1::Door.corridor_trigger)

    # Terminal - powered state controlled by stowage circuit panel
    terminal(
      x: 0,
      z: -10,
      powered: GameState.instance.get(:medbay_terminal_powered),
      welcome_clips: [Sounds::MedBay::Terminal.welcome],
      options: medbay_terminal_options
    )

    # Player spawn in corner (facing into room)
    player_spawn(x: -13, z: -4, rotation: 180)
  end

  private

  def medbay_terminal_options
    [
      diagnostic_kerrick_option,
      diagnostic_quinn_option,
      quarantine_status_option,
      cryo_sleep_option
    ]
  end

  def diagnostic_kerrick_option
    if GameState.instance.get(:medbay_diagnostic_pod_powered)
      {
        menu_item: Sounds::MedBay::Terminal.diagnostic_kerrick,
        on_select_clip: Sounds::MedBay::Terminal.diagnostic_kerrick_result_terminal,
        on_select_player_clip: Sounds::MedBay::Terminal.diagnostic_kerrick_result_quinn,
        on_select: -> { GameState.instance.update(kerrick_diagnosed: true) }
      }
    else
      {
        menu_item: Sounds::MedBay::Terminal.diagnostic_kerrick,
        on_select_clip: Sounds::MedBay::Terminal.diagnostic_kerrick_unpowered
      }
    end
  end

  def diagnostic_quinn_option
    if GameState.instance.get(:medbay_diagnostic_pod_powered)
      {
        menu_item: Sounds::MedBay::Terminal.diagnostic_quinn,
        on_select_clip: Sounds::MedBay::Terminal.diagnostic_quinn_result_terminal,
        on_select_player_clip: Sounds::MedBay::Terminal.diagnostic_quinn_result_quinn
      }
    else
      {
        menu_item: Sounds::MedBay::Terminal.diagnostic_quinn,
        on_select_clip: Sounds::MedBay::Terminal.diagnostic_quinn_unpowered
      }
    end
  end

  def quarantine_status_option
    {
      menu_item: Sounds::MedBay::Terminal.quarantine_status,
      on_select_clip: Sounds::MedBay::Terminal.quarantine_status_result_terminal,
      on_select_player_clip: Sounds::MedBay::Terminal.quarantine_status_result_quinn,
      on_select: -> { GameState.instance.update(quarantine_disabled: true) }
    }
  end

  def cryo_sleep_option
    {
      menu_item: Sounds::MedBay::Terminal.cryo_sleep,
      on_select_clip: Sounds::MedBay::Terminal.cryo_sleep_result_terminal,
      on_select_player_clip: Sounds::MedBay::Terminal.cryo_sleep_result_quinn,
      on_select: -> { GameState.instance.update(kerrick_in_cryo: true) }
    }
  end
end
