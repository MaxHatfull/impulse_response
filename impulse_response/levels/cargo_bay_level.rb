class CargoBayLevel < Level
  def create
    # Outer walls (30m x 30m)
    wall(x: 15, z: 0, width: 30, length: 1)       # top
    wall(x: 15, z: -31, width: 30, length: 1)     # bottom
    wall(x: 0, z: -15.5, width: 1, length: 30)    # left
    wall(x: 30, z: -15.5, width: 1, length: 30)   # right

    # Cargo boxes in grid (3x3 grid of boxes)
    (1..3).each do |row|
      (1..3).each do |col|
        box(x: 6 + col * 5, z: -6 - row * 6, size: 2)
      end
    end

    # Door back to intro
    door(x: 27, z: -28, level_class: IntroductionLevel, clip: "impulse_response/assets/sci_fi_audio/2 Sci Fi Sound.wav")

    # Player spawn at near corner
    player_spawn(x: 3, z: -3, rotation: 225)
  end

  private

  def box(x:, z:, size:)
    wall(x: x, z: z, width: size, length: size, height: size)
  end
end
