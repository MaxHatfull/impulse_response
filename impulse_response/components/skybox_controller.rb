class SkyboxController < Engine::Component
  LERP_DURATION = 1.0

  def awake
    @current_color = Vector[0, 0, 0]
    @target_color = Vector[0, 0, 0]
    @lerp_progress = 1.0
    apply_color(@current_color)
  end

  def set_color(color)
    @target_color = color
    @lerp_progress = 0.0
  end

  def update(delta_time)
    return if @lerp_progress >= 1.0

    @lerp_progress += delta_time / LERP_DURATION
    @lerp_progress = 1.0 if @lerp_progress > 1.0

    @current_color = lerp_vector(@current_color, @target_color, @lerp_progress)
    apply_color(@current_color)
  end

  private

  def lerp_vector(from, to, t)
    from + (to - from) * t
  end

  def apply_color(color)
    dim_color = color * 0.3
    Rendering::RenderPipeline.set_skybox_colors(
      ground: dim_color,
      horizon: dim_color,
      sky: color
    )
  end
end
