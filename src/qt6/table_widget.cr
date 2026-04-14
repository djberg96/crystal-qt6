module Qt6
  # Wraps `QTableWidget` for simple item-based tables.
  class TableWidget < Widget
    @current_cell_changed : Signal() = Signal().new
    @item_changed : Signal(TableWidgetItem) = Signal(TableWidgetItem).new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    # Signal emitted when the current cell changes.
    getter current_cell_changed : Signal()
    # Signal emitted when an item changes.
    getter item_changed : Signal(TableWidgetItem)

    # Creates a table widget with an optional parent.
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_table_widget_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      @current_cell_changed = Signal().new
      @item_changed = Signal(TableWidgetItem).new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_table_widget_on_current_cell_changed(to_unsafe, CURRENT_CELL_CHANGED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_table_widget_on_item_changed(to_unsafe, ITEM_CHANGED_TRAMPOLINE, @callback_userdata)
    end

    # Returns the number of rows.
    def row_count : Int32
      LibQt6.qt6cr_table_widget_row_count(to_unsafe)
    end

    # Sets the number of rows.
    def row_count=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_table_widget_set_row_count(to_unsafe, int_value)
      int_value
    end

    # Returns the number of columns.
    def column_count : Int32
      LibQt6.qt6cr_table_widget_column_count(to_unsafe)
    end

    # Sets the number of columns.
    def column_count=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_table_widget_set_column_count(to_unsafe, int_value)
      int_value
    end

    # Sets a horizontal header label and returns it.
    def set_horizontal_header_label(column : Int, value : String) : String
      LibQt6.qt6cr_table_widget_set_horizontal_header_label(to_unsafe, column.to_i32, value.to_unsafe)
      value
    end

    # Returns the horizontal header label for the given column.
    def horizontal_header_label(column : Int = 0) : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_table_widget_horizontal_header_label(to_unsafe, column.to_i32))
    end

    # Sets a vertical header label and returns it.
    def set_vertical_header_label(row : Int, value : String) : String
      LibQt6.qt6cr_table_widget_set_vertical_header_label(to_unsafe, row.to_i32, value.to_unsafe)
      value
    end

    # Returns the vertical header label for the given row.
    def vertical_header_label(row : Int = 0) : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_table_widget_vertical_header_label(to_unsafe, row.to_i32))
    end

    # Sets an item at the given row and column and returns it.
    def set_item(row : Int, column : Int, item : TableWidgetItem) : TableWidgetItem
      LibQt6.qt6cr_table_widget_set_item(to_unsafe, row.to_i32, column.to_i32, item.to_unsafe)
      item.adopt_by_parent!
      item
    end

    # Returns the item at the given row and column, if present.
    def item(row : Int, column : Int) : TableWidgetItem?
      handle = LibQt6.qt6cr_table_widget_item(to_unsafe, row.to_i32, column.to_i32)
      handle.null? ? nil : TableWidgetItem.wrap(handle)
    end

    # Returns the current item, if any.
    def current_item : TableWidgetItem?
      handle = LibQt6.qt6cr_table_widget_current_item(to_unsafe)
      handle.null? ? nil : TableWidgetItem.wrap(handle)
    end

    # Sets the current item and returns it.
    def current_item=(item : TableWidgetItem) : TableWidgetItem
      LibQt6.qt6cr_table_widget_set_current_item(to_unsafe, item.to_unsafe)
      item
    end

    # Returns the current row.
    def current_row : Int32
      LibQt6.qt6cr_table_widget_current_row(to_unsafe)
    end

    # Returns the current column.
    def current_column : Int32
      LibQt6.qt6cr_table_widget_current_column(to_unsafe)
    end

    # Sets the current cell and returns `self`.
    def set_current_cell(row : Int, column : Int) : self
      LibQt6.qt6cr_table_widget_set_current_cell(to_unsafe, row.to_i32, column.to_i32)
      self
    end

    # Removes all items and headers.
    def clear : self
      LibQt6.qt6cr_table_widget_clear(to_unsafe)
      self
    end

    # Removes only cell contents while keeping size and headers.
    def clear_contents : self
      LibQt6.qt6cr_table_widget_clear_contents(to_unsafe)
      self
    end

    # Returns the current selection mode.
    def selection_mode : ItemSelectionMode
      ItemSelectionMode.from_value(LibQt6.qt6cr_table_widget_selection_mode(to_unsafe))
    end

    # Sets the selection mode.
    def selection_mode=(value : ItemSelectionMode) : ItemSelectionMode
      LibQt6.qt6cr_table_widget_set_selection_mode(to_unsafe, value.value)
      value
    end

    # Returns whether alternating row colors are enabled.
    def alternating_row_colors? : Bool
      LibQt6.qt6cr_table_widget_alternating_row_colors(to_unsafe)
    end

    # Enables or disables alternating row colors.
    def alternating_row_colors=(value : Bool) : Bool
      LibQt6.qt6cr_table_widget_set_alternating_row_colors(to_unsafe, value)
      value
    end

    # Returns whether the cell grid is drawn.
    def show_grid? : Bool
      LibQt6.qt6cr_table_widget_show_grid(to_unsafe)
    end

    # Enables or disables cell grid drawing.
    def show_grid=(value : Bool) : Bool
      LibQt6.qt6cr_table_widget_set_show_grid(to_unsafe, value)
      value
    end

    # Returns the horizontal header view.
    def horizontal_header : HeaderView
      HeaderView.wrap(LibQt6.qt6cr_table_widget_horizontal_header(to_unsafe))
    end

    # Returns the vertical header view.
    def vertical_header : HeaderView
      HeaderView.wrap(LibQt6.qt6cr_table_widget_vertical_header(to_unsafe))
    end

    # Registers a block to run when the current cell changes.
    def on_current_cell_changed(&block : ->) : self
      @current_cell_changed.connect { block.call }
      self
    end

    # Registers a block to run when an item changes.
    def on_item_changed(&block : TableWidgetItem ->) : self
      @item_changed.connect { |item| block.call(item) }
      self
    end

    protected def emit_current_cell_changed : Nil
      @current_cell_changed.emit
    end

    protected def emit_item_changed(item : TableWidgetItem) : Nil
      @item_changed.emit(item)
    end

    private CURRENT_CELL_CHANGED_TRAMPOLINE = ->(userdata : Void*) do
      Box(TableWidget).unbox(userdata).emit_current_cell_changed
    end

    private ITEM_CHANGED_TRAMPOLINE = ->(userdata : Void*, handle : Void*) do
      Box(TableWidget).unbox(userdata).emit_item_changed(TableWidgetItem.wrap(handle))
    end
  end
end
