module Qt6
  # Wraps `QSlider`.
  class Slider < AbstractSlider
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a slider with the requested orientation and optional parent.
    def initialize(orientation : Orientation = Orientation::Horizontal, parent : Widget? = nil)
      super(LibQt6.qt6cr_slider_create(parent.try(&.to_unsafe) || Pointer(Void).null, orientation.value), parent.nil?)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns whether clicking the slider track jumps directly to that position.
    def click_to_position? : Bool
      LibQt6.qt6cr_slider_click_to_position(to_unsafe)
    end

    # Enables or disables click-to-position track behavior.
    def click_to_position=(value : Bool) : Bool
      LibQt6.qt6cr_slider_set_click_to_position(to_unsafe, value)
      value
    end

    # Returns the tick-mark placement around the slider groove.
    def tick_position : SliderTickPosition
      SliderTickPosition.from_value(LibQt6.qt6cr_slider_tick_position(to_unsafe))
    end

    # Sets the tick-mark placement and returns it.
    def tick_position=(value : SliderTickPosition) : SliderTickPosition
      LibQt6.qt6cr_slider_set_tick_position(to_unsafe, value.value)
      value
    end

    # Returns the tick-mark interval in slider value units.
    def tick_interval : Int32
      LibQt6.qt6cr_slider_tick_interval(to_unsafe)
    end

    # Sets the tick-mark interval and returns it.
    def tick_interval=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_slider_set_tick_interval(to_unsafe, int_value)
      int_value
    end

    # Returns the preferred size for the slider in its current configuration.
    def size_hint : Size
      Size.from_native(LibQt6.qt6cr_slider_size_hint(to_unsafe))
    end

    # Returns the minimum recommended size for the slider.
    def minimum_size_hint : Size
      Size.from_native(LibQt6.qt6cr_slider_minimum_size_hint(to_unsafe))
    end

    # Qt-style alias for `click_to_position=`.
    def set_click_to_position(value : Bool) : self
      self.click_to_position = value
      self
    end

    # Qt-style alias for `tick_position=`.
    def set_tick_position(value : SliderTickPosition) : self
      self.tick_position = value
      self
    end

    # Qt-style alias for `tick_interval=`.
    def set_tick_interval(value : Int) : self
      self.tick_interval = value
      self
    end
  end
end
