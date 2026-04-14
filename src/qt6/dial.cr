module Qt6
  # Wraps `QDial`.
  class Dial < Widget
    @value_changed : Signal(Int32) = Signal(Int32).new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    getter value_changed : Signal(Int32)

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_dial_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      @value_changed = Signal(Int32).new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_dial_on_value_changed(to_unsafe, VALUE_CHANGED_TRAMPOLINE, @callback_userdata)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      @value_changed = Signal(Int32).new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_dial_on_value_changed(to_unsafe, VALUE_CHANGED_TRAMPOLINE, @callback_userdata)
    end

    def minimum : Int32
      LibQt6.qt6cr_dial_minimum(to_unsafe)
    end

    def minimum=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_dial_set_minimum(to_unsafe, int_value)
      int_value
    end

    def maximum : Int32
      LibQt6.qt6cr_dial_maximum(to_unsafe)
    end

    def maximum=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_dial_set_maximum(to_unsafe, int_value)
      int_value
    end

    def set_range(minimum : Int, maximum : Int) : Range(Int32, Int32)
      min_value = minimum.to_i32
      max_value = maximum.to_i32
      LibQt6.qt6cr_dial_set_range(to_unsafe, min_value, max_value)
      min_value..max_value
    end

    def value : Int32
      LibQt6.qt6cr_dial_value(to_unsafe)
    end

    def value=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_dial_set_value(to_unsafe, int_value)
      int_value
    end

    def wrapping? : Bool
      LibQt6.qt6cr_dial_wrapping(to_unsafe)
    end

    def wrapping=(value : Bool) : Bool
      LibQt6.qt6cr_dial_set_wrapping(to_unsafe, value)
      value
    end

    def notches_visible? : Bool
      LibQt6.qt6cr_dial_notches_visible(to_unsafe)
    end

    def notches_visible=(value : Bool) : Bool
      LibQt6.qt6cr_dial_set_notches_visible(to_unsafe, value)
      value
    end

    def on_value_changed(&block : Int32 ->) : self
      @value_changed.connect { |value| block.call(value) }
      self
    end

    protected def emit_value_changed(value : Int32) : Nil
      @value_changed.emit(value)
    end

    private VALUE_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : Int32) do
      Box(Dial).unbox(userdata).emit_value_changed(value)
    end
  end
end
