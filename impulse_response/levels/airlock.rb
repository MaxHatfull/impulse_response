class Airlock < Level
  def bounds
    Physics::AABB.new(-10, -16, 10, 5)
  end

  def skybox_color
    Vector[0.75, 0.75, 0.75]  # Light grey
  end

  def create
    puts "loading airlock"

    # Small rectangular room (6m wide x 10m long)
    wall(x: -3, z: -5, width: 1, length: 10)     # left wall
    wall(x: 3, z: -5, width: 1, length: 10)      # right wall
    wall(x: 0, z: 0, width: 6, length: 1)        # back wall (entrance)
    wall(x: 0, z: -10, width: 6, length: 1)      # front wall

    # Door back to Level 1 corridor (behind player spawn)
    door(x: 0, z: -1, level_class: Level1Corridor, level_options: { from: :airlock }, trigger_clip: Sounds::Level1::Door.corridor_trigger, rotation: 180)

    # Player spawn (facing into room)
    player_spawn(x: 0, z: -4.5, rotation: 180)

    # Play find Kerrick dialogue on first entry
    # Quinn from player voice, terminal from scene source (both play simultaneously, timing baked into files)
    unless GameState.instance.get(:airlock_kerrick_found)
      GameState.instance.update(airlock_kerrick_found: true, carrying_kerrick: true)

      # Terminal voice in the room
      terminal_source = sound_source(x: 0, z: -5, clip: Sounds::Airlock.find_kerrick_terminal, loop: false, play_on_start: true)

      # Quinn voice from player
      Player.instance.voice_source.set_clip(Sounds::Airlock.find_kerrick_quinn)
      Player.instance.voice_source.play
    end
  end
end
