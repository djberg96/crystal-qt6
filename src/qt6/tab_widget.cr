module Qt6
  # Wraps `QTabWidget`.
  class TabWidget < Widget
    @current_index_changed : Signal(Int32) = Signal(Int32).new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    # Signal emitted when the current tab changes.
    getter current_index_changed : Signal(Int32)

    # Creates a tab widget with an optional parent.
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_tab_widget_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      @current_index_changed = Signal(Int32).new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_tab_widget_on_current_index_changed(to_unsafe, INDEX_CHANGED_TRAMPOLINE, @callback_userdata)
    end

    # Adds a page widget with the given tab label and returns the page.
    def add_tab(widget : Widget, label : String) : Widget
      LibQt6.qt6cr_tab_widget_add_tab(to_unsafe, widget.to_unsafe, label.to_unsafe)
      widget.adopt_by_parent!
      widget
    end

    # Returns the number of tabs.
    def count : Int32
      LibQt6.qt6cr_tab_widget_count(to_unsafe)
    end

    # Returns the selected tab index.
    def current_index : Int32
      LibQt6.qt6cr_tab_widget_current_index(to_unsafe)
    end

    # Changes the selected tab index and returns the assigned value.
    def current_index=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_tab_widget_set_current_index(to_unsafe, int_value)
      int_value
    end

    # Registers a block to run when the selected tab changes.
    def on_current_index_changed(&block : Int32 ->) : self
      @current_index_changed.connect { |value| block.call(value) }
      self
    end

    protected def emit_current_index_changed(value : Int32) : Nil
      @current_index_changed.emit(value)
    end

    private INDEX_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : Int32) do
      Box(TabWidget).unbox(userdata).emit_current_index_changed(value)
    end
  end
end