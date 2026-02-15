class CallbackDevice
  attr_reader :powered

  def initialize(on_power_on: nil, on_power_off: nil, powered: false)
    @powered = powered
    @on_power_on = on_power_on
    @on_power_off = on_power_off
  end

  def power_on
    @powered = true
    @on_power_on&.call
  end

  def power_off
    @powered = false
    @on_power_off&.call
  end
end
