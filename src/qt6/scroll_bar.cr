module Qt6
  # Wraps `QScrollBar`.
  class ScrollBar < Widget
    @value_changed : Signal(Int32) = Signal(Int32).new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    getter value_changed : Signal(Int32)

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(orientation : Orientation = Orientation::Vertical, parent : Widget? = nil)
      super(LibQt6.qt6cr_scroll_bar_create(parent.try(&.to_unsafe) || Pointer(Void).null, orientation.value), parent.nil?)
      @value_changed = Signal(Int32).new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_scroll_bar_on_value_changed(to_unsafe, VALUE_CHANGED_TRAMPOLINE, @callback_userdata)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      @value_changed = Signal(Int32).new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_scroll_bar_on_value_changed(to_unsafe, VALUE_CHANGED_TRAMPOLINE, @callback_userdata)
    end

    def orientation : Orientation
      Orientation.from_value(LibQt6.qt6cr_scroll_bar_orientation(to_unsafe))
    end

    def minimum : Int32
      LibQt6.qt6cr_scroll_bar_minimum(to_unsafe)
    end

    def minimum=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_scroll_bar_set_minimum(to_unsafe, int_value)
      int_value
    end

    def maximum : Int32
      LibQt6.qt6cr_scroll_bar_maximum(to_unsafe)
    end

    def maximum=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_scroll_bar_set_maximum(to_unsafe, int_value)
      int_value
    end

    def set_range(minimum : Int, maximum : Int) : Range(Int32, Int32)
      min_value = minimum.to_i32
      max_value = maximum.to_i32
      LibQt6.qt6cr_scroll_bar_set_range(to_unsafe, min_value, max_value)
      min_value..max_value
    end

    def value : Int32
      LibQt6.qt6cr_scroll_bar_value(to_unsafe)
    end

    def value=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_scroll_bar_set_value(to_unsafe, int_value)
      int_value
    end

    def single_step : Int32
      LibQt6.qt6cr_scroll_bar_single_step(to_unsafe)
    end

    def single_step=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_scroll_bar_set_single_step(to_unsafe, int_value)
      int_value
    end

    def page_step : Int32
      LibQt6.qt6cr_scroll_bar_page_step(to_unsafe)
    end

    def page_step=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_scroll_bar_set_page_step(to_unsafe, int_value)
      int_value
    end

    def on_value_changed(&block : Int32 ->) : self
      @value_changed.connect { |value| block.call(value) }
      self
    end

    protected def emit_value_changed(value : Int32) : Nil
      @value_changed.emit(value)
    end

    private VALUE_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : Int32) do
      Box(ScrollBar).unbox(userdata).emit_value_changed(value)
    end
  end
end
