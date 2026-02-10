class IntroductionLevel < Level
  def create
    # Corridor walls (4m wide, 30m long)
    wall(x: 0, z: -15, width: 1, length: 30)      # left wall
    wall(x: 5, z: -15, width: 1, length: 30)      # right wall
    wall(x: 2.5, z: 0, width: 4, length: 1)       # back wall (behind player)
    wall(x: 2.5, z: -30, width: 4, length: 1)     # front wall (behind sound)

    # Terminal halfway along corridor
    terminal(
      x: 2.5,
      z: -15,
      welcome_clip: NativeAudio::Clip.new("impulse_response/assets/audio/cryo_room/terminal/Welcome.wav"),
      options: [
        {
          menu_item: NativeAudio::Clip.new("impulse_response/assets/audio/cryo_room/terminal/Ship Status.wav"),
        },
        {
          menu_item: NativeAudio::Clip.new("impulse_response/assets/audio/cryo_room/terminal/Crew Status.wav"),
        },
        {
          menu_item: NativeAudio::Clip.new("impulse_response/assets/audio/cryo_room/terminal/CryoPod Status.wav"),
        },
        {
          menu_item: NativeAudio::Clip.new("impulse_response/assets/audio/cryo_room/terminal/Emergency Cryopod override.wav"),
          on_select: NativeAudio::Clip.new("impulse_response/assets/audio/cryo_room/terminal/Emergency CryoPod Override selected.wav")
        },
        {
          menu_item: NativeAudio::Clip.new("impulse_response/assets/audio/cryo_room/terminal/Health Check.wav"),
          on_select: NativeAudio::Clip.new("impulse_response/assets/audio/cryo_room/terminal/Health Check completed.wav")
        }
      ]
    )

    # Door to cargo bay
    door(x: 2.5, z: -28, level_class: CargoBayLevel)

    # Player spawn at near end
    player_spawn(x: 2.5, z: -2, rotation: 180)
  end
end
