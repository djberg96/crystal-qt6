module Qt6
  # Wraps `QDoubleSpinBox`.
  class DoubleSpinBox < AbstractSpinBox
    @text_changed : Signal(String) = Signal(String).new
    @value_changed : Signal(Float64) = Signal(Float64).new
    @text_changed_userdata : LibQt6::Handle = Pointer(Void).null
    @value_changed_userdata : LibQt6::Handle = Pointer(Void).null

    # Signal emitted whenever the displayed text changes.
    getter text_changed : Signal(String)
    # Signal emitted whenever the double spin-box value changes.
    getter value_changed : Signal(Float64)

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a double spin box with an optional parent.
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_double_spin_box_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      register_callbacks
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      register_callbacks
    end

    private def register_callbacks : Nil
      @text_changed = Signal(String).new
      @value_changed = Signal(Float64).new
      @text_changed_userdata = Box.box(self)
      @value_changed_userdata = Box.box(self)
      LibQt6.qt6cr_double_spin_box_on_text_changed(to_unsafe, TEXT_CHANGED_TRAMPOLINE, @text_changed_userdata)
      LibQt6.qt6cr_double_spin_box_on_value_changed(to_unsafe, VALUE_CHANGED_TRAMPOLINE, @value_changed_userdata)
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

    # Returns how the step size adapts while stepping.
    def step_type : AbstractSpinBoxStepType
      AbstractSpinBoxStepType.from_value(LibQt6.qt6cr_double_spin_box_step_type(to_unsafe))
    end

    # Sets how the step size adapts while stepping.
    def step_type=(value : AbstractSpinBoxStepType) : AbstractSpinBoxStepType
      LibQt6.qt6cr_double_spin_box_set_step_type(to_unsafe, value.value)
      value
    end

    # Returns the number of displayed decimal places.
    def decimals : Int32
      LibQt6.qt6cr_double_spin_box_decimals(to_unsafe)
    end

    # Sets the number of displayed decimal places.
    def decimals=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_double_spin_box_set_decimals(to_unsafe, int_value)
      int_value
    end

    # Returns the text shown before the numeric value.
    def prefix : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_double_spin_box_prefix(to_unsafe))
    end

    # Sets the text shown before the numeric value.
    def prefix=(value : String) : String
      LibQt6.qt6cr_double_spin_box_set_prefix(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the text shown after the numeric value.
    def suffix : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_double_spin_box_suffix(to_unsafe))
    end

    # Sets the text shown after the numeric value.
    def suffix=(value : String) : String
      LibQt6.qt6cr_double_spin_box_set_suffix(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the current text without prefix, suffix, or surrounding spaces.
    def clean_text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_double_spin_box_clean_text(to_unsafe))
    end

    # Registers a block to run when the displayed text changes.
    def on_text_changed(&block : String ->) : self
      @text_changed.connect { |value| block.call(value) }
      self
    end

    # Registers a block to run when the double spin-box value changes.
    def on_value_changed(&block : Float64 ->) : self
      @value_changed.connect { |value| block.call(value) }
      self
    end

    protected def emit_text_changed(value : UInt8*) : Nil
      @text_changed.emit(Qt6.copy_string(value))
    end

    protected def emit_value_changed(value : Float64) : Nil
      @value_changed.emit(value)
    end

    private TEXT_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : UInt8*) do
      Box(DoubleSpinBox).unbox(userdata).emit_text_changed(value)
    end

    private VALUE_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : Float64) do
      Box(DoubleSpinBox).unbox(userdata).emit_value_changed(value)
    end
  end
end
