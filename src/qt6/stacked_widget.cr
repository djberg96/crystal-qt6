module Qt6
  # Wraps `QStackedWidget`.
  class StackedWidget < Frame
    @current_index_changed : Signal(Int32) = Signal(Int32).new
    @widget_removed : Signal(Int32) = Signal(Int32).new
    @widget_added : Signal(Int32) = Signal(Int32).new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    getter current_index_changed : Signal(Int32)
    getter widget_removed : Signal(Int32)
    getter widget_added : Signal(Int32)

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def self.widget_added_available? : Bool
      LibQt6.qt6cr_stacked_widget_widget_added_available
    end

    # Creates a stacked widget with an optional parent.
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_stacked_widget_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      register_callbacks
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      register_callbacks
    end

    # Adds a page widget and returns it.
    def add(widget : Widget) : Widget
      LibQt6.qt6cr_stacked_widget_add_widget(to_unsafe, widget.to_unsafe)
      widget.adopt_by_parent!
      widget
    end

    # Adds a page widget and returns it.
    def add_widget(widget : Widget) : Widget
      add(widget)
    end

    # Inserts a page widget at the given index and returns it.
    def insert(index : Int, widget : Widget) : Widget
      LibQt6.qt6cr_stacked_widget_insert_widget(to_unsafe, index.to_i32, widget.to_unsafe)
      widget.adopt_by_parent!
      widget
    end

    # Qt-style alias for `insert`.
    def insert_widget(index : Int, widget : Widget) : Widget
      insert(index, widget)
    end

    # Returns the page widget at the given index, if present.
    def widget(index : Int) : Widget?
      handle = LibQt6.qt6cr_stacked_widget_widget(to_unsafe, index.to_i32)
      handle.null? ? nil : Widget.wrap(handle)
    end

    # Appends a page widget and returns `self`.
    def <<(widget : Widget) : self
      add_widget(widget)
      self
    end

    # Returns the number of pages.
    def count : Int32
      LibQt6.qt6cr_stacked_widget_count(to_unsafe)
    end

    # Returns the selected page index.
    def current_index : Int32
      LibQt6.qt6cr_stacked_widget_current_index(to_unsafe)
    end

    # Changes the selected page index and returns the assigned value.
    def current_index=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_stacked_widget_set_current_index(to_unsafe, int_value)
      int_value
    end

    # Returns the currently selected page widget, if present.
    def current_widget : Widget?
      handle = LibQt6.qt6cr_stacked_widget_current_widget(to_unsafe)
      handle.null? ? nil : Widget.wrap(handle)
    end

    # Changes the selected page widget and returns it.
    def current_widget=(widget : Widget) : Widget
      LibQt6.qt6cr_stacked_widget_set_current_widget(to_unsafe, widget.to_unsafe)
      widget
    end

    # Returns the index of the given page widget, or `-1` when absent.
    def index_of(widget : Widget) : Int32
      LibQt6.qt6cr_stacked_widget_index_of(to_unsafe, widget.to_unsafe)
    end

    # Removes the given page widget from the stack.
    def remove_widget(widget : Widget) : self
      LibQt6.qt6cr_stacked_widget_remove_widget(to_unsafe, widget.to_unsafe)
      self
    end

    # Qt-style alias for selecting the current page widget.
    def set_current_widget(widget : Widget) : self
      self.current_widget = widget
      self
    end

    # Qt-style alias for `current_index=`.
    def set_current_index(value : Int) : self
      self.current_index = value
      self
    end

    # Registers a block to run when the selected page changes.
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
      LibQt6.qt6cr_stacked_widget_on_current_index_changed(to_unsafe, INDEX_CHANGED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_stacked_widget_on_widget_removed(to_unsafe, WIDGET_REMOVED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_stacked_widget_on_widget_added(to_unsafe, WIDGET_ADDED_TRAMPOLINE, @callback_userdata)
    end

    private INDEX_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : Int32) do
      Box(StackedWidget).unbox(userdata).emit_current_index_changed(value)
    end

    private WIDGET_REMOVED_TRAMPOLINE = ->(userdata : Void*, value : Int32) do
      Box(StackedWidget).unbox(userdata).emit_widget_removed(value)
    end

    private WIDGET_ADDED_TRAMPOLINE = ->(userdata : Void*, value : Int32) do
      Box(StackedWidget).unbox(userdata).emit_widget_added(value)
    end
  end
end
