module Qt6
  # Wraps `QSlider`.
  class Slider < Widget
    @value_changed : Signal(Int32) = Signal(Int32).new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    # Signal emitted whenever the slider value changes.
    getter value_changed : Signal(Int32)

    # Creates a slider with the requested orientation and optional parent.
    def initialize(orientation : Orientation = Orientation::Horizontal, parent : Widget? = nil)
      super(LibQt6.qt6cr_slider_create(parent.try(&.to_unsafe) || Pointer(Void).null, orientation.value), parent.nil?)
      @value_changed = Signal(Int32).new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_slider_on_value_changed(to_unsafe, VALUE_CHANGED_TRAMPOLINE, @callback_userdata)
    end

    # Returns the slider orientation.
    def orientation : Orientation
      Orientation.from_value(LibQt6.qt6cr_slider_orientation(to_unsafe))
    end

    # Returns the slider minimum value.
    def minimum : Int32
      LibQt6.qt6cr_slider_minimum(to_unsafe)
    end

    # Sets the slider minimum value.
    def minimum=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_slider_set_minimum(to_unsafe, int_value)
      int_value
    end

    # Returns the slider maximum value.
    def maximum : Int32
      LibQt6.qt6cr_slider_maximum(to_unsafe)
    end

    # Sets the slider maximum value.
    def maximum=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_slider_set_maximum(to_unsafe, int_value)
      int_value
    end

    # Sets the slider range and returns it.
    def set_range(minimum : Int, maximum : Int) : Range(Int32, Int32)
      min_value = minimum.to_i32
      max_value = maximum.to_i32
      LibQt6.qt6cr_slider_set_range(to_unsafe, min_value, max_value)
      min_value..max_value
    end

    # Returns the current slider value.
    def value : Int32
      LibQt6.qt6cr_slider_value(to_unsafe)
    end

    # Sets the current slider value.
    def value=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_slider_set_value(to_unsafe, int_value)
      int_value
    end

    # Registers a block to run when the slider value changes.
    def on_value_changed(&block : Int32 ->) : self
      @value_changed.connect { |value| block.call(value) }
      self
    end

    protected def emit_value_changed(value : Int32) : Nil
      @value_changed.emit(value)
    end

    private VALUE_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : Int32) do
      Box(Slider).unbox(userdata).emit_value_changed(value)
    end
  end
end