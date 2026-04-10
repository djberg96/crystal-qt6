module Qt6
  # Wraps `QListWidget` for simple item-based side panels.
  class ListWidget < Widget
    @current_row_changed : Signal(Int32) = Signal(Int32).new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    # Signal emitted when the current row changes.
    getter current_row_changed : Signal(Int32)

    # Creates a list widget with an optional parent.
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_list_widget_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      @current_row_changed = Signal(Int32).new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_list_widget_on_current_row_changed(to_unsafe, ROW_CHANGED_TRAMPOLINE, @callback_userdata)
    end

    # Adds an existing item to the widget and returns it.
    def add_item(item : ListWidgetItem) : ListWidgetItem
      LibQt6.qt6cr_list_widget_add_item(to_unsafe, item.to_unsafe)
      item.adopt_by_parent!
      item
    end

    # Creates, adds, and returns a borrowed item for the given text.
    def add_item(text : String) : ListWidgetItem
      ListWidgetItem.wrap(LibQt6.qt6cr_list_widget_add_item_text(to_unsafe, text.to_unsafe))
    end

    # Appends an item and returns `self`.
    def <<(item : ListWidgetItem) : self
      add_item(item)
      self
    end

    # Appends a text item and returns `self`.
    def <<(text : String) : self
      add_item(text)
      self
    end

    # Returns the number of items.
    def count : Int32
      LibQt6.qt6cr_list_widget_count(to_unsafe)
    end

    # Returns the item at the given index, if present.
    def item(index : Int) : ListWidgetItem?
      handle = LibQt6.qt6cr_list_widget_item(to_unsafe, index.to_i32)
      handle.null? ? nil : ListWidgetItem.wrap(handle)
    end

    # Returns the text of the item at the given index.
    def item_text(index : Int) : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_list_widget_item_text_at(to_unsafe, index.to_i32))
    end

    # Returns the selected row.
    def current_row : Int32
      LibQt6.qt6cr_list_widget_current_row(to_unsafe)
    end

    # Changes the selected row and returns it.
    def current_row=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_list_widget_set_current_row(to_unsafe, int_value)
      int_value
    end

    # Returns the current item, if any.
    def current_item : ListWidgetItem?
      handle = LibQt6.qt6cr_list_widget_current_item(to_unsafe)
      handle.null? ? nil : ListWidgetItem.wrap(handle)
    end

    # Returns the current item text.
    def current_text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_list_widget_current_text(to_unsafe))
    end

    # Removes all items.
    def clear : self
      LibQt6.qt6cr_list_widget_clear(to_unsafe)
      self
    end

    # Registers a block to run when the current row changes.
    def on_current_row_changed(&block : Int32 ->) : self
      @current_row_changed.connect { |value| block.call(value) }
      self
    end

    protected def emit_current_row_changed(value : Int32) : Nil
      @current_row_changed.emit(value)
    end

    private ROW_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : Int32) do
      Box(ListWidget).unbox(userdata).emit_current_row_changed(value)
    end
  end
end