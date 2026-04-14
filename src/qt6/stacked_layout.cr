module Qt6
  # Wraps `QStackedLayout`.
  class StackedLayout < Layout
    @current_index_changed : Signal(Int32) = Signal(Int32).new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    getter current_index_changed : Signal(Int32)

    def initialize(parent : Widget)
      super(LibQt6.qt6cr_stacked_layout_create(parent.to_unsafe))
      @current_index_changed = Signal(Int32).new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_stacked_layout_on_current_index_changed(@to_unsafe, INDEX_CHANGED_TRAMPOLINE, @callback_userdata)
    end

    def add(widget : Widget) : Widget
      LibQt6.qt6cr_stacked_layout_add_widget(@to_unsafe, widget.to_unsafe)
      adopt(widget)
    end

    def <<(widget : Widget) : self
      add(widget)
      self
    end

    def count : Int32
      LibQt6.qt6cr_stacked_layout_count(@to_unsafe)
    end

    def current_index : Int32
      LibQt6.qt6cr_stacked_layout_current_index(@to_unsafe)
    end

    def current_index=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_stacked_layout_set_current_index(@to_unsafe, int_value)
      int_value
    end

    def on_current_index_changed(&block : Int32 ->) : self
      @current_index_changed.connect { |value| block.call(value) }
      self
    end

    protected def emit_current_index_changed(value : Int32) : Nil
      @current_index_changed.emit(value)
    end

    private INDEX_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : Int32) do
      Box(StackedLayout).unbox(userdata).emit_current_index_changed(value)
    end
  end
end
