module Qt6
  # Wraps `QSpinBox`.
  class SpinBox < AbstractSpinBox
    @value_changed : Signal(Int32) = Signal(Int32).new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    # Signal emitted whenever the spin-box value changes.
    getter value_changed : Signal(Int32)

    # Creates a spin box with an optional parent.
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_spin_box_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      @value_changed = Signal(Int32).new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_spin_box_on_value_changed(to_unsafe, VALUE_CHANGED_TRAMPOLINE, @callback_userdata)
    end

    # Returns the minimum allowed value.
    def minimum : Int32
      LibQt6.qt6cr_spin_box_minimum(to_unsafe)
    end

    # Sets the minimum allowed value.
    def minimum=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_spin_box_set_minimum(to_unsafe, int_value)
      int_value
    end

    # Returns the maximum allowed value.
    def maximum : Int32
      LibQt6.qt6cr_spin_box_maximum(to_unsafe)
    end

    # Sets the maximum allowed value.
    def maximum=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_spin_box_set_maximum(to_unsafe, int_value)
      int_value
    end

    # Sets the allowed range and returns it.
    def set_range(minimum : Int, maximum : Int) : Range(Int32, Int32)
      min_value = minimum.to_i32
      max_value = maximum.to_i32
      LibQt6.qt6cr_spin_box_set_range(to_unsafe, min_value, max_value)
      min_value..max_value
    end

    # Returns the current spin-box value.
    def value : Int32
      LibQt6.qt6cr_spin_box_value(to_unsafe)
    end

    # Sets the current spin-box value.
    def value=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_spin_box_set_value(to_unsafe, int_value)
      int_value
    end

    # Returns the step size.
    def single_step : Int32
      LibQt6.qt6cr_spin_box_single_step(to_unsafe)
    end

    # Sets the step size.
    def single_step=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_spin_box_set_single_step(to_unsafe, int_value)
      int_value
    end

    # Returns the text shown before the numeric value.
    def prefix : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_spin_box_prefix(to_unsafe))
    end

    # Sets the text shown before the numeric value.
    def prefix=(value : String) : String
      LibQt6.qt6cr_spin_box_set_prefix(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the text shown after the numeric value.
    def suffix : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_spin_box_suffix(to_unsafe))
    end

    # Sets the text shown after the numeric value.
    def suffix=(value : String) : String
      LibQt6.qt6cr_spin_box_set_suffix(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the special text displayed at the minimum value.
    def special_value_text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_spin_box_special_value_text(to_unsafe))
    end

    # Sets the special text displayed at the minimum value.
    def special_value_text=(value : String) : String
      LibQt6.qt6cr_spin_box_set_special_value_text(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the current text without prefix, suffix, or surrounding spaces.
    def clean_text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_spin_box_clean_text(to_unsafe))
    end

    # Registers a block to run when the spin-box value changes.
    def on_value_changed(&block : Int32 ->) : self
      @value_changed.connect { |value| block.call(value) }
      self
    end

    protected def emit_value_changed(value : Int32) : Nil
      @value_changed.emit(value)
    end

    private VALUE_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : Int32) do
      Box(SpinBox).unbox(userdata).emit_value_changed(value)
    end
  end
end
