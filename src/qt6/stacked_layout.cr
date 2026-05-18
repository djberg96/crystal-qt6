module Qt6
  # Wraps `QStackedLayout`.
  class StackedLayout < Layout
    @current_index_changed : Signal(Int32) = Signal(Int32).new
    @widget_removed : Signal(Int32) = Signal(Int32).new
    @widget_added : Signal(Int32) = Signal(Int32).new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    getter current_index_changed : Signal(Int32)
    getter widget_removed : Signal(Int32)
    getter widget_added : Signal(Int32)

    def self.wrap(handle : LibQt6::Handle) : self
      new(handle)
    end

    # Creates a stacked layout attached to an optional parent widget.
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_stacked_layout_create(parent.try(&.to_unsafe) || Pointer(Void).null))
      register_callbacks
    end

    protected def initialize(handle : LibQt6::Handle)
      super(handle)
      register_callbacks
    end

    # Adds a page widget and returns it.
    def add(widget : Widget) : Widget
      LibQt6.qt6cr_stacked_layout_add_widget(to_unsafe, widget.to_unsafe)
      adopt(widget)
    end

    # Qt-style alias for `add`.
    def add_widget(widget : Widget) : Widget
      add(widget)
    end

    # Inserts a page widget at the given index and returns it.
    def insert(index : Int, widget : Widget) : Widget
      LibQt6.qt6cr_stacked_layout_insert_widget(to_unsafe, index.to_i32, widget.to_unsafe)
      adopt(widget)
    end

    # Qt-style alias for `insert`.
    def insert_widget(index : Int, widget : Widget) : Widget
      insert(index, widget)
    end

    def <<(widget : Widget) : self
      add(widget)
      self
    end

    def count : Int32
      LibQt6.qt6cr_stacked_layout_count(to_unsafe)
    end

    # Returns the page widget at the given index, if present.
    def widget(index : Int) : Widget?
      handle = LibQt6.qt6cr_stacked_layout_widget(to_unsafe, index.to_i32)
      handle.null? ? nil : Widget.wrap(handle)
    end

    # Returns the currently selected page widget, if present.
    def current_widget : Widget?
      handle = LibQt6.qt6cr_stacked_layout_current_widget(to_unsafe)
      handle.null? ? nil : Widget.wrap(handle)
    end

    def current_index : Int32
      LibQt6.qt6cr_stacked_layout_current_index(to_unsafe)
    end

    def current_index=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_stacked_layout_set_current_index(to_unsafe, int_value)
      int_value
    end

    # Changes the selected page widget and returns it.
    def current_widget=(widget : Widget) : Widget
      LibQt6.qt6cr_stacked_layout_set_current_widget(to_unsafe, widget.to_unsafe)
      widget
    end

    # Returns the current stacking mode.
    def stacking_mode : StackedLayoutStackingMode
      StackedLayoutStackingMode.from_value(LibQt6.qt6cr_stacked_layout_stacking_mode(to_unsafe))
    end

    # Sets the stacking mode and returns it.
    def stacking_mode=(value : StackedLayoutStackingMode) : StackedLayoutStackingMode
      LibQt6.qt6cr_stacked_layout_set_stacking_mode(to_unsafe, value.value)
      value
    end

    # Qt-style alias for `current_index=`.
    def set_current_index(value : Int) : self
      self.current_index = value
      self
    end

    # Qt-style alias for `current_widget=`.
    def set_current_widget(widget : Widget) : self
      self.current_widget = widget
      self
    end

    # Qt-style alias for `stacking_mode=`.
    def set_stacking_mode(value : StackedLayoutStackingMode) : self
      self.stacking_mode = value
      self
    end

    def on_current_index_changed(&block : Int32 ->) : self
      @current_index_changed.connect { |value| block.call(value) }
      self
    end

    # Registers a block to run when a page is removed.
    def on_widget_removed(&block : Int32 ->) : self
      @widget_removed.connect { |value| block.call(value) }
      self
    end

    # Registers a block to run when a page is added.
    def on_widget_added(&block : Int32 ->) : self
      @widget_added.connect { |value| block.call(value) }
      self
    end

    protected def emit_current_index_changed(value : Int32) : Nil
      @current_index_changed.emit(value)
    end

    protected def emit_widget_removed(value : Int32) : Nil
      @widget_removed.emit(value)
    end

    protected def emit_widget_added(value : Int32) : Nil
      @widget_added.emit(value)
    end

    private def register_callbacks : Nil
      @current_index_changed = Signal(Int32).new
      @widget_removed = Signal(Int32).new
      @widget_added = Signal(Int32).new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_stacked_layout_on_current_index_changed(to_unsafe, INDEX_CHANGED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_stacked_layout_on_widget_removed(to_unsafe, WIDGET_REMOVED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_stacked_layout_on_widget_added(to_unsafe, WIDGET_ADDED_TRAMPOLINE, @callback_userdata)
    end

    private INDEX_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : Int32) do
      Box(StackedLayout).unbox(userdata).emit_current_index_changed(value)
    end

    private WIDGET_REMOVED_TRAMPOLINE = ->(userdata : Void*, value : Int32) do
      Box(StackedLayout).unbox(userdata).emit_widget_removed(value)
    end

    private WIDGET_ADDED_TRAMPOLINE = ->(userdata : Void*, value : Int32) do
      Box(StackedLayout).unbox(userdata).emit_widget_added(value)
    end
  end
end
