module Qt6
  # Wraps `QToolBox`.
  class ToolBox < Frame
    @current_index_changed : Signal(Int32) = Signal(Int32).new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    getter current_index_changed : Signal(Int32)

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a tool box with an optional parent.
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_tool_box_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      @current_index_changed = Signal(Int32).new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_tool_box_on_current_index_changed(to_unsafe, INDEX_CHANGED_TRAMPOLINE, @callback_userdata)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      @current_index_changed = Signal(Int32).new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_tool_box_on_current_index_changed(to_unsafe, INDEX_CHANGED_TRAMPOLINE, @callback_userdata)
    end

    # Adds a page with a text label and returns the page widget.
    def add_item(widget : Widget, label : String) : Widget
      LibQt6.qt6cr_tool_box_add_item(to_unsafe, widget.to_unsafe, label.to_unsafe)
      widget.adopt_by_parent!
      widget
    end

    # Adds a page with an icon and text label and returns the page widget.
    def add_item(widget : Widget, icon : QIcon, label : String) : Widget
      LibQt6.qt6cr_tool_box_add_item_with_icon(to_unsafe, widget.to_unsafe, icon.to_unsafe, label.to_unsafe)
      widget.adopt_by_parent!
      widget
    end

    # Inserts a page with a text label and returns the page widget.
    def insert_item(index : Int, widget : Widget, label : String) : Widget
      LibQt6.qt6cr_tool_box_insert_item(to_unsafe, index.to_i32, widget.to_unsafe, label.to_unsafe)
      widget.adopt_by_parent!
      widget
    end

    # Inserts a page with an icon and text label and returns the page widget.
    def insert_item(index : Int, widget : Widget, icon : QIcon, label : String) : Widget
      LibQt6.qt6cr_tool_box_insert_item_with_icon(to_unsafe, index.to_i32, widget.to_unsafe, icon.to_unsafe, label.to_unsafe)
      widget.adopt_by_parent!
      widget
    end

    # Removes the page at the given index.
    def remove_item(index : Int) : self
      LibQt6.qt6cr_tool_box_remove_item(to_unsafe, index.to_i32)
      self
    end

    # Enables or disables the page at the given index.
    def set_item_enabled(index : Int, value : Bool) : Bool
      LibQt6.qt6cr_tool_box_set_item_enabled(to_unsafe, index.to_i32, value)
      value
    end

    # Returns `true` when the page at the given index is enabled.
    def item_enabled?(index : Int) : Bool
      LibQt6.qt6cr_tool_box_item_enabled(to_unsafe, index.to_i32)
    end

    # Sets the page label and returns it.
    def set_item_text(index : Int, value : String) : String
      LibQt6.qt6cr_tool_box_set_item_text(to_unsafe, index.to_i32, value.to_unsafe)
      value
    end

    # Returns the page label at the given index.
    def item_text(index : Int) : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_tool_box_item_text(to_unsafe, index.to_i32))
    end

    # Sets the page icon and returns it.
    def set_item_icon(index : Int, value : QIcon) : QIcon
      LibQt6.qt6cr_tool_box_set_item_icon(to_unsafe, index.to_i32, value.to_unsafe)
      value
    end

    # Returns the page icon at the given index.
    def item_icon(index : Int) : QIcon
      QIcon.wrap(LibQt6.qt6cr_tool_box_item_icon(to_unsafe, index.to_i32), true)
    end

    # Sets the page tooltip and returns it.
    def set_item_tool_tip(index : Int, value : String) : String
      LibQt6.qt6cr_tool_box_set_item_tool_tip(to_unsafe, index.to_i32, value.to_unsafe)
      value
    end

    # Returns the page tooltip at the given index.
    def item_tool_tip(index : Int) : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_tool_box_item_tool_tip(to_unsafe, index.to_i32))
    end

    # Returns the selected page index.
    def current_index : Int32
      LibQt6.qt6cr_tool_box_current_index(to_unsafe)
    end

    # Changes the selected page index and returns the assigned value.
    def current_index=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_tool_box_set_current_index(to_unsafe, int_value)
      int_value
    end

    # Returns the currently selected page widget, if present.
    def current_widget : Widget?
      handle = LibQt6.qt6cr_tool_box_current_widget(to_unsafe)
      handle.null? ? nil : Widget.wrap(handle)
    end

    # Changes the selected page widget and returns it.
    def current_widget=(widget : Widget) : Widget
      LibQt6.qt6cr_tool_box_set_current_widget(to_unsafe, widget.to_unsafe)
      widget
    end

    # Returns the page widget at the given index, if present.
    def widget(index : Int) : Widget?
      handle = LibQt6.qt6cr_tool_box_widget(to_unsafe, index.to_i32)
      handle.null? ? nil : Widget.wrap(handle)
    end

    # Returns the index of the given widget, or `-1` when absent.
    def index_of(widget : Widget) : Int32
      LibQt6.qt6cr_tool_box_index_of(to_unsafe, widget.to_unsafe)
    end

    # Returns the number of pages.
    def count : Int32
      LibQt6.qt6cr_tool_box_count(to_unsafe)
    end

    # Registers a block to run when the selected page changes.
    def on_current_index_changed(&block : Int32 ->) : self
      @current_index_changed.connect { |value| block.call(value) }
      self
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

    protected def emit_current_index_changed(value : Int32) : Nil
      @current_index_changed.emit(value)
    end

    private INDEX_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : Int32) do
      Box(ToolBox).unbox(userdata).emit_current_index_changed(value)
    end
  end
end
