module Qt6
  # Wraps `QAbstractSlider` behavior shared by sliders, scroll bars, and dials.
  class AbstractSlider < Widget
    @value_changed : Signal(Int32) = Signal(Int32).new
    @slider_moved : Signal(Int32) = Signal(Int32).new
    @action_triggered : Signal(AbstractSliderAction) = Signal(AbstractSliderAction).new
    @range_changed : Signal(Int32, Int32) = Signal(Int32, Int32).new
    @pressed : Signal() = Signal().new
    @released : Signal() = Signal().new
    @value_changed_userdata : LibQt6::Handle = Pointer(Void).null
    @slider_moved_userdata : LibQt6::Handle = Pointer(Void).null
    @action_triggered_userdata : LibQt6::Handle = Pointer(Void).null
    @range_changed_userdata : LibQt6::Handle = Pointer(Void).null
    @pressed_userdata : LibQt6::Handle = Pointer(Void).null
    @released_userdata : LibQt6::Handle = Pointer(Void).null

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    getter value_changed : Signal(Int32)
    getter slider_moved : Signal(Int32)
    getter action_triggered : Signal(AbstractSliderAction)
    getter range_changed : Signal(Int32, Int32)
    getter pressed : Signal()
    getter released : Signal()

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      register_slider_callbacks
    end

    # Returns the current orientation.
    def orientation : Orientation
      Orientation.from_value(LibQt6.qt6cr_abstract_slider_orientation(to_unsafe))
    end

    # Sets the orientation and returns it.
    def orientation=(value : Orientation) : Orientation
      LibQt6.qt6cr_abstract_slider_set_orientation(to_unsafe, value.value)
      value
    end

    # Returns the minimum value.
    def minimum : Int32
      LibQt6.qt6cr_abstract_slider_minimum(to_unsafe)
    end

    # Sets the minimum value.
    def minimum=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_abstract_slider_set_minimum(to_unsafe, int_value)
      int_value
    end

    # Returns the maximum value.
    def maximum : Int32
      LibQt6.qt6cr_abstract_slider_maximum(to_unsafe)
    end

    # Sets the maximum value.
    def maximum=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_abstract_slider_set_maximum(to_unsafe, int_value)
      int_value
    end

    # Sets the range and returns it.
    def set_range(minimum : Int, maximum : Int) : Range(Int32, Int32)
      min_value = minimum.to_i32
      max_value = maximum.to_i32
      LibQt6.qt6cr_abstract_slider_set_range(to_unsafe, min_value, max_value)
      min_value..max_value
    end

    # Returns the current value.
    def value : Int32
      LibQt6.qt6cr_abstract_slider_value(to_unsafe)
    end

    # Sets the current value.
    def value=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_abstract_slider_set_value(to_unsafe, int_value)
      int_value
    end

    # Returns the single-step increment.
    def single_step : Int32
      LibQt6.qt6cr_abstract_slider_single_step(to_unsafe)
    end

    # Sets the single-step increment.
    def single_step=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_abstract_slider_set_single_step(to_unsafe, int_value)
      int_value
    end

    # Returns the page-step increment.
    def page_step : Int32
      LibQt6.qt6cr_abstract_slider_page_step(to_unsafe)
    end

    # Sets the page-step increment.
    def page_step=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_abstract_slider_set_page_step(to_unsafe, int_value)
      int_value
    end

    # Returns the current slider position.
    def slider_position : Int32
      LibQt6.qt6cr_abstract_slider_slider_position(to_unsafe)
    end

    # Sets the current slider position.
    def slider_position=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_abstract_slider_set_slider_position(to_unsafe, int_value)
      int_value
    end

    # Returns `true` when tracking updates the value continuously while dragging.
    def tracking? : Bool
      LibQt6.qt6cr_abstract_slider_tracking(to_unsafe)
    end

    # Enables or disables continuous tracking while dragging.
    def tracking=(value : Bool) : Bool
      LibQt6.qt6cr_abstract_slider_set_tracking(to_unsafe, value)
      value
    end

    # Returns `true` when the slider is currently pressed down.
    def slider_down? : Bool
      LibQt6.qt6cr_abstract_slider_slider_down(to_unsafe)
    end

    # Sets whether the slider is currently pressed down.
    def slider_down=(value : Bool) : Bool
      LibQt6.qt6cr_abstract_slider_set_slider_down(to_unsafe, value)
      value
    end

    # Returns `true` when the visual appearance is inverted.
    def inverted_appearance? : Bool
      LibQt6.qt6cr_abstract_slider_inverted_appearance(to_unsafe)
    end

    # Enables or disables inverted visual appearance.
    def inverted_appearance=(value : Bool) : Bool
      LibQt6.qt6cr_abstract_slider_set_inverted_appearance(to_unsafe, value)
      value
    end

    # Returns `true` when input controls are inverted.
    def inverted_controls? : Bool
      LibQt6.qt6cr_abstract_slider_inverted_controls(to_unsafe)
    end

    # Enables or disables inverted input controls.
    def inverted_controls=(value : Bool) : Bool
      LibQt6.qt6cr_abstract_slider_set_inverted_controls(to_unsafe, value)
      value
    end

    # Triggers one of the standard slider actions.
    def trigger_action(action : AbstractSliderAction) : self
      LibQt6.qt6cr_abstract_slider_trigger_action(to_unsafe, action.value)
      self
    end

    # Registers a block to run when the value changes.
    def on_value_changed(&block : Int32 ->) : self
      @value_changed.connect { |value| block.call(value) }
      self
    end

    # Registers a block to run when the slider handle moves.
    def on_slider_moved(&block : Int32 ->) : self
      @slider_moved.connect { |value| block.call(value) }
      self
    end

    # Registers a block to run when a standard action is triggered.
    def on_action_triggered(&block : AbstractSliderAction ->) : self
      @action_triggered.connect { |action| block.call(action) }
      self
    end

    # Registers a block to run when the allowed range changes.
    def on_range_changed(&block : Int32, Int32 ->) : self
      @range_changed.connect { |minimum, maximum| block.call(minimum, maximum) }
      self
    end

    # Registers a block to run when the slider is pressed.
    def on_pressed(&block : ->) : self
      @pressed.connect { block.call }
      self
    end

    # Registers a block to run when the slider is released.
    def on_released(&block : ->) : self
      @released.connect { block.call }
      self
    end

    protected def emit_value_changed(value : Int32) : Nil
      @value_changed.emit(value)
    end

    protected def emit_slider_moved(value : Int32) : Nil
      @slider_moved.emit(value)
    end

    protected def emit_action_triggered(action : Int32) : Nil
      @action_triggered.emit(AbstractSliderAction.from_value(action))
    end

    protected def emit_range_changed(minimum : Int32, maximum : Int32) : Nil
      @range_changed.emit(minimum, maximum)
    end

    protected def emit_pressed : Nil
      @pressed.emit
    end

    protected def emit_released : Nil
      @released.emit
    end

    private def register_slider_callbacks : Nil
      @value_changed = Signal(Int32).new
      @slider_moved = Signal(Int32).new
      @action_triggered = Signal(AbstractSliderAction).new
      @range_changed = Signal(Int32, Int32).new
      @pressed = Signal().new
      @released = Signal().new
      @value_changed_userdata = Box.box(self.as(AbstractSlider))
      @slider_moved_userdata = Box.box(self.as(AbstractSlider))
      @action_triggered_userdata = Box.box(self.as(AbstractSlider))
      @range_changed_userdata = Box.box(self.as(AbstractSlider))
      @pressed_userdata = Box.box(self.as(AbstractSlider))
      @released_userdata = Box.box(self.as(AbstractSlider))
      LibQt6.qt6cr_abstract_slider_on_value_changed(to_unsafe, VALUE_CHANGED_TRAMPOLINE, @value_changed_userdata)
      LibQt6.qt6cr_abstract_slider_on_slider_moved(to_unsafe, SLIDER_MOVED_TRAMPOLINE, @slider_moved_userdata)
      LibQt6.qt6cr_abstract_slider_on_action_triggered(to_unsafe, ACTION_TRIGGERED_TRAMPOLINE, @action_triggered_userdata)
      LibQt6.qt6cr_abstract_slider_on_range_changed(to_unsafe, RANGE_CHANGED_TRAMPOLINE, @range_changed_userdata)
      LibQt6.qt6cr_abstract_slider_on_pressed(to_unsafe, PRESSED_TRAMPOLINE, @pressed_userdata)
      LibQt6.qt6cr_abstract_slider_on_released(to_unsafe, RELEASED_TRAMPOLINE, @released_userdata)
    end

    private VALUE_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : Int32) do
      Box(AbstractSlider).unbox(userdata).emit_value_changed(value)
    end

    private SLIDER_MOVED_TRAMPOLINE = ->(userdata : Void*, value : Int32) do
      Box(AbstractSlider).unbox(userdata).emit_slider_moved(value)
    end

    private ACTION_TRIGGERED_TRAMPOLINE = ->(userdata : Void*, action : Int32) do
      Box(AbstractSlider).unbox(userdata).emit_action_triggered(action)
    end

    private RANGE_CHANGED_TRAMPOLINE = ->(userdata : Void*, minimum : Int32, maximum : Int32) do
      Box(AbstractSlider).unbox(userdata).emit_range_changed(minimum, maximum)
    end

    private PRESSED_TRAMPOLINE = ->(userdata : Void*) do
      Box(AbstractSlider).unbox(userdata).emit_pressed
    end

    private RELEASED_TRAMPOLINE = ->(userdata : Void*) do
      Box(AbstractSlider).unbox(userdata).emit_released
    end
  end
end
