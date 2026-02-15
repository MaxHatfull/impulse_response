class Level
  def initialize(level_root)
    @level_root = level_root
  end

  def create(**)
    raise NotImplementedError, "Subclasses must implement #create"
  end

  def bounds
    raise NotImplementedError, "Subclasses must implement #bounds"
  end

  def skybox_color
    Vector[0, 0, 0]  # Default to black
  end

  def wall(x:, z:, width:, length:, height: 1, rotation: 0)
    Level::Wall.create(parent: @level_root, x: x, z: z, width: width, length: length, height: height, rotation: rotation)
  end

  def sound_source(x:, z:, clip: nil, beam_length: 40, beam_count: 64, volume: 10, loop: true, play_on_start: true)
    Level::SoundSource.create(parent: @level_root, x: x, z: z, clip: clip, beam_length: beam_length, beam_count: beam_count, volume: volume, loop: loop, play_on_start: play_on_start)
  end

  def player_spawn(x:, z:, rotation: 0)
    Player.instance.reset(Vector[x, 0, z], rotation: rotation)
  end

  def door(x:, z:, level_class:, radius: 2, powered: true, locked: false, trigger_clip: nil, level_options: {})
    Level::Door.create(parent: @level_root, x: x, z: z, level_class: level_class, radius: radius, powered: powered, locked: locked, trigger_clip: trigger_clip, level_options: level_options)
  end

  def terminal(x:, z:, options: [], welcome_clips: [], powered: true, locked: false)
    Level::Terminal.create(parent: @level_root, x: x, z: z, options: options, welcome_clips: welcome_clips, powered: powered, locked: locked)
  end

  def circuit_panel(x:, z:, devices: [], welcome_clip: nil, total_power: 1, locked: false)
    Level::CircuitPanel.create(parent: @level_root, x: x, z: z, devices: devices, welcome_clip: welcome_clip, total_power: total_power, locked: locked)
  end
end
