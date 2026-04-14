module Qt6
  # Wraps `QDoubleSpinBox`.
  class DoubleSpinBox < AbstractSpinBox
    @value_changed : Signal(Float64) = Signal(Float64).new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    # Signal emitted whenever the double spin-box value changes.
    getter value_changed : Signal(Float64)

    # Creates a double spin box with an optional parent.
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_double_spin_box_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      @value_changed = Signal(Float64).new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_double_spin_box_on_value_changed(to_unsafe, VALUE_CHANGED_TRAMPOLINE, @callback_userdata)
    end

    # Returns the minimum allowed value.
    def minimum : Float64
      LibQt6.qt6cr_double_spin_box_minimum(to_unsafe)
    end

    # Sets the minimum allowed value.
    def minimum=(value : Number) : Float64
      float_value = value.to_f64
      LibQt6.qt6cr_double_spin_box_set_minimum(to_unsafe, float_value)
      float_value
    end

    # Returns the maximum allowed value.
    def maximum : Float64
      LibQt6.qt6cr_double_spin_box_maximum(to_unsafe)
    end

    # Sets the maximum allowed value.
    def maximum=(value : Number) : Float64
      float_value = value.to_f64
      LibQt6.qt6cr_double_spin_box_set_maximum(to_unsafe, float_value)
      float_value
    end

    # Sets the allowed range and returns it.
    def set_range(minimum : Number, maximum : Number) : Range(Float64, Float64)
      min_value = minimum.to_f64
      max_value = maximum.to_f64
      LibQt6.qt6cr_double_spin_box_set_range(to_unsafe, min_value, max_value)
      min_value..max_value
    end

    # Returns the current double spin-box value.
    def value : Float64
      LibQt6.qt6cr_double_spin_box_value(to_unsafe)
    end

    # Sets the current double spin-box value.
    def value=(value : Number) : Float64
      float_value = value.to_f64
      LibQt6.qt6cr_double_spin_box_set_value(to_unsafe, float_value)
      float_value
    end

    # Returns the step size.
    def single_step : Float64
      LibQt6.qt6cr_double_spin_box_single_step(to_unsafe)
    end

    # Sets the step size.
    def single_step=(value : Number) : Float64
      float_value = value.to_f64
      LibQt6.qt6cr_double_spin_box_set_single_step(to_unsafe, float_value)
      float_value
    end

    # Registers a block to run when the double spin-box value changes.
    def on_value_changed(&block : Float64 ->) : self
      @value_changed.connect { |value| block.call(value) }
      self
    end

    protected def emit_value_changed(value : Float64) : Nil
      @value_changed.emit(value)
    end

    private VALUE_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : Float64) do
      Box(DoubleSpinBox).unbox(userdata).emit_value_changed(value)
    end
  end
end
