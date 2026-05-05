module Qt6
  # Wraps `QSlider`.
  class Slider < AbstractSlider
    # Creates a slider with the requested orientation and optional parent.
    def initialize(orientation : Orientation = Orientation::Horizontal, parent : Widget? = nil)
      super(LibQt6.qt6cr_slider_create(parent.try(&.to_unsafe) || Pointer(Void).null, orientation.value), parent.nil?)
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
  end
end
