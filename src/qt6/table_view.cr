module Qt6
  # Wraps `QTableView` for model-driven tabular displays.
  class TableView < AbstractItemView
    @current_index_changed : Signal() = Signal().new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    # Signal emitted when the current index changes.
    getter current_index_changed : Signal()

    # Creates a table view with an optional parent.
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_table_view_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      @current_index_changed = Signal().new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_table_view_on_current_index_changed(to_unsafe, CURRENT_INDEX_CHANGED_TRAMPOLINE, @callback_userdata)
    end

    # Assigns the backing model and returns it.
    def model=(model : AbstractItemModel) : AbstractItemModel
      LibQt6.qt6cr_table_view_set_model(to_unsafe, model.to_unsafe)
      model
    end

    # Returns whether the cell grid is drawn.
    def show_grid? : Bool
      LibQt6.qt6cr_table_view_show_grid(to_unsafe)
    end

    # Enables or disables cell grid drawing.
    def show_grid=(value : Bool) : Bool
      LibQt6.qt6cr_table_view_set_show_grid(to_unsafe, value)
      value
    end

    # Returns whether cell text is wrapped.
    def word_wrap? : Bool
      LibQt6.qt6cr_table_view_word_wrap(to_unsafe)
    end

    # Enables or disables cell text wrapping.
    def word_wrap=(value : Bool) : Bool
      LibQt6.qt6cr_table_view_set_word_wrap(to_unsafe, value)
      value
    end

    # Returns whether sorting is enabled.
    def sorting_enabled? : Bool
      LibQt6.qt6cr_table_view_sorting_enabled(to_unsafe)
    end

    # Enables or disables built-in sorting.
    def sorting_enabled=(value : Bool) : Bool
      LibQt6.qt6cr_table_view_set_sorting_enabled(to_unsafe, value)
      value
    end

    # Returns the horizontal header view.
    def horizontal_header : HeaderView
      HeaderView.wrap(LibQt6.qt6cr_table_view_horizontal_header(to_unsafe))
    end

    # Installs the horizontal header view and returns it.
    def horizontal_header=(header : HeaderView) : HeaderView
      LibQt6.qt6cr_table_view_set_horizontal_header(to_unsafe, header.to_unsafe)
      header.adopt_by_parent!
      header
    end

    # Qt-style alias for `horizontal_header=`.
    def set_horizontal_header(header : HeaderView) : self
      self.horizontal_header = header
      self
    end

    # Returns the vertical header view.
    def vertical_header : HeaderView
      HeaderView.wrap(LibQt6.qt6cr_table_view_vertical_header(to_unsafe))
    end

    # Installs the vertical header view and returns it.
    def vertical_header=(header : HeaderView) : HeaderView
      LibQt6.qt6cr_table_view_set_vertical_header(to_unsafe, header.to_unsafe)
      header.adopt_by_parent!
      header
    end

    # Qt-style alias for `vertical_header=`.
    def set_vertical_header(header : HeaderView) : self
      self.vertical_header = header
      self
    end

    # Returns the y coordinate of the given row within the viewport.
    def row_viewport_position(row : Int) : Int32
      LibQt6.qt6cr_table_view_row_viewport_position(to_unsafe, row.to_i32)
    end

    # Returns the row at the given viewport y coordinate, or `-1`.
    def row_at(y : Int) : Int32
      LibQt6.qt6cr_table_view_row_at(to_unsafe, y.to_i32)
    end

    # Sets the height for the given row and returns `self`.
    def set_row_height(row : Int, height : Int) : self
      LibQt6.qt6cr_table_view_set_row_height(to_unsafe, row.to_i32, height.to_i32)
      self
    end

    # Returns the current height of the given row.
    def row_height(row : Int) : Int32
      LibQt6.qt6cr_table_view_row_height(to_unsafe, row.to_i32)
    end

    # Returns the x coordinate of the given column within the viewport.
    def column_viewport_position(column : Int) : Int32
      LibQt6.qt6cr_table_view_column_viewport_position(to_unsafe, column.to_i32)
    end

    # Returns the column at the given viewport x coordinate, or `-1`.
    def column_at(x : Int) : Int32
      LibQt6.qt6cr_table_view_column_at(to_unsafe, x.to_i32)
    end

    # Sets the width for the given column and returns `self`.
    def set_column_width(column : Int, width : Int) : self
      LibQt6.qt6cr_table_view_set_column_width(to_unsafe, column.to_i32, width.to_i32)
      self
    end

    # Returns the current width of the given column.
    def column_width(column : Int) : Int32
      LibQt6.qt6cr_table_view_column_width(to_unsafe, column.to_i32)
    end

    # Returns whether the given row is hidden.
    def row_hidden?(row : Int) : Bool
      LibQt6.qt6cr_table_view_row_hidden(to_unsafe, row.to_i32)
    end

    # Shows or hides the given row.
    def set_row_hidden(row : Int, value : Bool) : Bool
      LibQt6.qt6cr_table_view_set_row_hidden(to_unsafe, row.to_i32, value)
      value
    end

    # Returns whether the given column is hidden.
    def column_hidden?(column : Int) : Bool
      LibQt6.qt6cr_table_view_column_hidden(to_unsafe, column.to_i32)
    end

    # Shows or hides the given column.
    def set_column_hidden(column : Int, value : Bool) : Bool
      LibQt6.qt6cr_table_view_set_column_hidden(to_unsafe, column.to_i32, value)
      value
    end

    # Returns the pen style used to draw the cell grid.
    def grid_style : PenStyle
      PenStyle.from_value(LibQt6.qt6cr_table_view_grid_style(to_unsafe))
    end

    # Sets the pen style used to draw the cell grid.
    def grid_style=(value : PenStyle) : PenStyle
      LibQt6.qt6cr_table_view_set_grid_style(to_unsafe, value.value)
      value
    end

    # Qt-style alias for `grid_style=`.
    def set_grid_style(value : PenStyle) : self
      self.grid_style = value
      self
    end

    # Returns whether the top-left corner button is enabled.
    def corner_button_enabled? : Bool
      LibQt6.qt6cr_table_view_corner_button_enabled(to_unsafe)
    end

    # Enables or disables the top-left corner button.
    def corner_button_enabled=(value : Bool) : Bool
      LibQt6.qt6cr_table_view_set_corner_button_enabled(to_unsafe, value)
      value
    end

    # Qt-style alias for `corner_button_enabled=`.
    def set_corner_button_enabled(value : Bool) : self
      self.corner_button_enabled = value
      self
    end

    # Sets a visual span for the given cell.
    def set_span(row : Int, column : Int, row_span : Int, column_span : Int) : self
      LibQt6.qt6cr_table_view_set_span(to_unsafe, row.to_i32, column.to_i32, row_span.to_i32, column_span.to_i32)
      self
    end

    # Returns the current visual row span for the given cell.
    def row_span(row : Int, column : Int) : Int32
      LibQt6.qt6cr_table_view_row_span(to_unsafe, row.to_i32, column.to_i32)
    end

    # Returns the current visual column span for the given cell.
    def column_span(row : Int, column : Int) : Int32
      LibQt6.qt6cr_table_view_column_span(to_unsafe, row.to_i32, column.to_i32)
    end

    # Clears all custom spans from the table.
    def clear_spans : self
      LibQt6.qt6cr_table_view_clear_spans(to_unsafe)
      self
    end

    # Selects the entire row according to the current selection behavior.
    def select_row(row : Int) : self
      LibQt6.qt6cr_table_view_select_row(to_unsafe, row.to_i32)
      self
    end

    # Selects the entire column according to the current selection behavior.
    def select_column(column : Int) : self
      LibQt6.qt6cr_table_view_select_column(to_unsafe, column.to_i32)
      self
    end

    # Hides the given row and returns `self`.
    def hide_row(row : Int) : self
      LibQt6.qt6cr_table_view_hide_row(to_unsafe, row.to_i32)
      self
    end

    # Shows the given row and returns `self`.
    def show_row(row : Int) : self
      LibQt6.qt6cr_table_view_show_row(to_unsafe, row.to_i32)
      self
    end

    # Hides the given column and returns `self`.
    def hide_column(column : Int) : self
      LibQt6.qt6cr_table_view_hide_column(to_unsafe, column.to_i32)
      self
    end

    # Shows the given column and returns `self`.
    def show_column(column : Int) : self
      LibQt6.qt6cr_table_view_show_column(to_unsafe, column.to_i32)
      self
    end

    # Resizes the given row to fit its current contents.
    def resize_row_to_contents(row : Int) : self
      LibQt6.qt6cr_table_view_resize_row_to_contents(to_unsafe, row.to_i32)
      self
    end

    # Resizes the given column to fit its current contents.
    def resize_column_to_contents(column : Int) : self
      LibQt6.qt6cr_table_view_resize_column_to_contents(to_unsafe, column.to_i32)
      self
    end

    # Sorts rows by the given column and order.
    def sort_by_column(column : Int, order : SortOrder = SortOrder::Ascending) : self
      LibQt6.qt6cr_table_view_sort_by_column(to_unsafe, column.to_i32, order.value)
      self
    end

    # Resizes all columns to fit their current contents.
    def resize_columns_to_contents : self
      LibQt6.qt6cr_table_view_resize_columns_to_contents(to_unsafe)
      self
    end

    # Resizes all rows to fit their current contents.
    def resize_rows_to_contents : self
      LibQt6.qt6cr_table_view_resize_rows_to_contents(to_unsafe)
      self
    end

    # Registers a block to run when the current index changes.
    def on_current_index_changed(&block : ->) : self
      @current_index_changed.connect { block.call }
      self
    end

    protected def emit_current_index_changed : Nil
      @current_index_changed.emit
    end

    private CURRENT_INDEX_CHANGED_TRAMPOLINE = ->(userdata : Void*) do
      Box(TableView).unbox(userdata).emit_current_index_changed
    end
  end
end
