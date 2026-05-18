module Qt6
  # Wraps `QGridLayout`.
  class GridLayout < Layout
    # Creates a grid layout attached to the given parent widget when present.
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_grid_layout_create(parent.try(&.to_unsafe) || Pointer(Void).null))
    end

    # Adds a widget at the given grid position.
    #
    # `row_span` and `column_span` default to `1`.
    def add(widget : Widget, row : Int, column : Int, row_span : Int = 1, column_span : Int = 1, alignment : AlignmentFlag = AlignmentFlag::None) : Widget
      LibQt6.qt6cr_grid_layout_add_widget(@to_unsafe, widget.to_unsafe, row, column, row_span, column_span, alignment.value)
      adopt(widget)
    end

    # Adds a child layout at the given grid position.
    def add(layout : Layout, row : Int, column : Int, row_span : Int = 1, column_span : Int = 1, alignment : AlignmentFlag = AlignmentFlag::None) : Layout
      LibQt6.qt6cr_grid_layout_add_layout(@to_unsafe, layout.to_unsafe, row, column, row_span, column_span, alignment.value)
      layout.adopt_by_parent!
      layout
    end

    # Adds a spacer item at the given grid position.
    def add(item : SpacerItem, row : Int, column : Int, row_span : Int = 1, column_span : Int = 1, alignment : AlignmentFlag = AlignmentFlag::None) : SpacerItem
      LibQt6.qt6cr_grid_layout_add_spacer_item(@to_unsafe, item.to_unsafe, row, column, row_span, column_span, alignment.value)
      item.adopt_by_owner!
      item
    end

    # Returns the horizontal spacing override between columns.
    def horizontal_spacing : Int32
      LibQt6.qt6cr_grid_layout_horizontal_spacing(@to_unsafe)
    end

    # Sets the horizontal spacing override between columns.
    def horizontal_spacing=(value : Int) : Int32
      LibQt6.qt6cr_grid_layout_set_horizontal_spacing(@to_unsafe, value.to_i32)
      value.to_i32
    end

    # Returns the vertical spacing override between rows.
    def vertical_spacing : Int32
      LibQt6.qt6cr_grid_layout_vertical_spacing(@to_unsafe)
    end

    # Sets the vertical spacing override between rows.
    def vertical_spacing=(value : Int) : Int32
      LibQt6.qt6cr_grid_layout_set_vertical_spacing(@to_unsafe, value.to_i32)
      value.to_i32
    end

    # Sets the stretch factor for the given row.
    def set_row_stretch(row : Int, stretch : Int) : self
      LibQt6.qt6cr_grid_layout_set_row_stretch(@to_unsafe, row.to_i32, stretch.to_i32)
      self
    end

    # Returns the stretch factor for the given row.
    def row_stretch(row : Int) : Int32
      LibQt6.qt6cr_grid_layout_row_stretch(@to_unsafe, row.to_i32)
    end

    # Sets the minimum height for the given row.
    def set_row_minimum_height(row : Int, height : Int) : self
      LibQt6.qt6cr_grid_layout_set_row_minimum_height(@to_unsafe, row.to_i32, height.to_i32)
      self
    end

    # Returns the minimum height for the given row.
    def row_minimum_height(row : Int) : Int32
      LibQt6.qt6cr_grid_layout_row_minimum_height(@to_unsafe, row.to_i32)
    end

    # Sets the stretch factor for the given column.
    def set_column_stretch(column : Int, stretch : Int) : self
      LibQt6.qt6cr_grid_layout_set_column_stretch(@to_unsafe, column.to_i32, stretch.to_i32)
      self
    end

    # Returns the stretch factor for the given column.
    def column_stretch(column : Int) : Int32
      LibQt6.qt6cr_grid_layout_column_stretch(@to_unsafe, column.to_i32)
    end

    # Sets the minimum width for the given column.
    def set_column_minimum_width(column : Int, width : Int) : self
      LibQt6.qt6cr_grid_layout_set_column_minimum_width(@to_unsafe, column.to_i32, width.to_i32)
      self
    end

    # Returns the minimum width for the given column.
    def column_minimum_width(column : Int) : Int32
      LibQt6.qt6cr_grid_layout_column_minimum_width(@to_unsafe, column.to_i32)
    end

    # Returns the number of rows with layout structure.
    def row_count : Int32
      LibQt6.qt6cr_grid_layout_row_count(@to_unsafe)
    end

    # Returns the number of columns with layout structure.
    def column_count : Int32
      LibQt6.qt6cr_grid_layout_column_count(@to_unsafe)
    end

    # Returns the geometry of the given cell in parent coordinates.
    def cell_rect(row : Int, column : Int) : Rect
      Rect.from_native(LibQt6.qt6cr_grid_layout_cell_rect(@to_unsafe, row.to_i32, column.to_i32))
    end

    # Returns the layout item at the given row and column, if present.
    def item_at_position(row : Int, column : Int) : LayoutItem?
      handle = LibQt6.qt6cr_grid_layout_item_at_position(@to_unsafe, row.to_i32, column.to_i32)
      handle.null? ? nil : LayoutItem.wrap(handle, false)
    end

    # Returns the origin corner used for grid growth.
    def origin_corner : Corner
      Corner.from_value(LibQt6.qt6cr_grid_layout_origin_corner(@to_unsafe))
    end

    # Sets the origin corner used for grid growth.
    def origin_corner=(value : Corner) : Corner
      LibQt6.qt6cr_grid_layout_set_origin_corner(@to_unsafe, value.value)
      value
    end
  end
end
