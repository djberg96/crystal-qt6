module Qt6
  # Wraps `QListWidget` for simple item-based side panels.
  class ListWidget < Widget
    @current_row_changed : Signal(Int32) = Signal(Int32).new
    @item_changed : Signal(ListWidgetItem) = Signal(ListWidgetItem).new
    @item_double_clicked : Signal(ListWidgetItem) = Signal(ListWidgetItem).new
    @rows_moved : Signal() = Signal().new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    # Signal emitted when the current row changes.
    getter current_row_changed : Signal(Int32)
    # Signal emitted when an item is changed.
    getter item_changed : Signal(ListWidgetItem)
    # Signal emitted when an item is double-clicked.
    getter item_double_clicked : Signal(ListWidgetItem)
    # Signal emitted when rows are reordered via the underlying model.
    getter rows_moved : Signal()

    # Creates a list widget with an optional parent.
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_list_widget_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      @current_row_changed = Signal(Int32).new
      @item_changed = Signal(ListWidgetItem).new
      @item_double_clicked = Signal(ListWidgetItem).new
      @rows_moved = Signal().new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_list_widget_on_current_row_changed(to_unsafe, ROW_CHANGED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_list_widget_on_item_changed(to_unsafe, ITEM_CHANGED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_list_widget_on_item_double_clicked(to_unsafe, ITEM_DOUBLE_CLICKED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_list_widget_on_rows_moved(to_unsafe, ROWS_MOVED_TRAMPOLINE, @callback_userdata)
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

    # Returns the spacing between items.
    def spacing : Int32
      LibQt6.qt6cr_list_widget_spacing(to_unsafe)
    end

    # Sets the spacing between items.
    def spacing=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_list_widget_set_spacing(to_unsafe, int_value)
      int_value
    end

    # Returns the current drag/drop mode.
    def drag_drop_mode : ItemViewDragDropMode
      ItemViewDragDropMode.from_value(LibQt6.qt6cr_list_widget_drag_drop_mode(to_unsafe))
    end

    # Sets the drag/drop mode.
    def drag_drop_mode=(value : ItemViewDragDropMode) : ItemViewDragDropMode
      LibQt6.qt6cr_list_widget_set_drag_drop_mode(to_unsafe, value.value)
      value
    end

    # Returns the current selection mode.
    def selection_mode : ItemSelectionMode
      ItemSelectionMode.from_value(LibQt6.qt6cr_list_widget_selection_mode(to_unsafe))
    end

    # Sets the selection mode.
    def selection_mode=(value : ItemSelectionMode) : ItemSelectionMode
      LibQt6.qt6cr_list_widget_set_selection_mode(to_unsafe, value.value)
      value
    end

    # Returns the default drop action.
    def default_drop_action : DropAction
      DropAction.from_value(LibQt6.qt6cr_list_widget_default_drop_action(to_unsafe))
    end

    # Sets the default drop action.
    def default_drop_action=(value : DropAction) : DropAction
      LibQt6.qt6cr_list_widget_set_default_drop_action(to_unsafe, value.value)
      value
    end

    # Reorders an item within the list.
    def move_item(from : Int, to : Int) : Bool
      LibQt6.qt6cr_list_widget_move_item(to_unsafe, from.to_i32, to.to_i32)
    end

    # Registers a block to run when the current row changes.
    def on_current_row_changed(&block : Int32 ->) : self
      @current_row_changed.connect { |value| block.call(value) }
      self
    end

    # Registers a block to run when an item changes.
    def on_item_changed(&block : ListWidgetItem ->) : self
      @item_changed.connect { |item| block.call(item) }
      self
    end

    # Registers a block to run when an item is double-clicked.
    def on_item_double_clicked(&block : ListWidgetItem ->) : self
      @item_double_clicked.connect { |item| block.call(item) }
      self
    end

    # Registers a block to run when rows are moved.
    def on_rows_moved(&block : ->) : self
      @rows_moved.connect { block.call }
      self
    end

    protected def emit_current_row_changed(value : Int32) : Nil
      @current_row_changed.emit(value)
    end

    protected def emit_item_changed(item : ListWidgetItem) : Nil
      @item_changed.emit(item)
    end

    protected def emit_item_double_clicked(item : ListWidgetItem) : Nil
      @item_double_clicked.emit(item)
    end

    protected def emit_rows_moved : Nil
      @rows_moved.emit
    end

    private ROW_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : Int32) do
      Box(ListWidget).unbox(userdata).emit_current_row_changed(value)
    end

    private ITEM_CHANGED_TRAMPOLINE = ->(userdata : Void*, handle : Void*) do
      Box(ListWidget).unbox(userdata).emit_item_changed(ListWidgetItem.wrap(handle))
    end

    private ITEM_DOUBLE_CLICKED_TRAMPOLINE = ->(userdata : Void*, handle : Void*) do
      Box(ListWidget).unbox(userdata).emit_item_double_clicked(ListWidgetItem.wrap(handle))
    end

    private ROWS_MOVED_TRAMPOLINE = ->(userdata : Void*) do
      Box(ListWidget).unbox(userdata).emit_rows_moved
    end
  end
end
