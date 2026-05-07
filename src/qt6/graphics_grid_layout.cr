module Qt6
  # Wraps `QGraphicsGridLayout`.
  class GraphicsGridLayout < GraphicsLayout
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a graphics grid layout with an optional parent graphics widget.
    def initialize(parent : GraphicsWidget? = nil)
      super(LibQt6.qt6cr_graphics_grid_layout_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Adds a graphics widget to the given row and column.
    def add_item(item : GraphicsWidget, row : Int, column : Int, alignment : AlignmentFlag = AlignmentFlag::AlignLeft) : self
      add_item(item, row, column, 1, 1, alignment)
    end

    # Adds a graphics widget spanning the given rows and columns.
    def add_item(item : GraphicsWidget, row : Int, column : Int, row_span : Int, column_span : Int, alignment : AlignmentFlag = AlignmentFlag::AlignLeft) : self
      LibQt6.qt6cr_graphics_grid_layout_add_item(
        to_unsafe,
        item.to_unsafe,
        row.to_i,
        column.to_i,
        row_span.to_i,
        column_span.to_i,
        alignment.value
      )
      self
    end

    def spacing=(value : Number) : Float64
      spacing = value.to_f64
      LibQt6.qt6cr_graphics_grid_layout_set_spacing(to_unsafe, spacing)
      spacing
    end

    def horizontal_spacing=(value : Number) : Float64
      spacing = value.to_f64
      LibQt6.qt6cr_graphics_grid_layout_set_horizontal_spacing(to_unsafe, spacing)
      spacing
    end

    def vertical_spacing=(value : Number) : Float64
      spacing = value.to_f64
      LibQt6.qt6cr_graphics_grid_layout_set_vertical_spacing(to_unsafe, spacing)
      spacing
    end

    def horizontal_spacing : Float64
      LibQt6.qt6cr_graphics_grid_layout_horizontal_spacing(to_unsafe)
    end

    def vertical_spacing : Float64
      LibQt6.qt6cr_graphics_grid_layout_vertical_spacing(to_unsafe)
    end

    def set_row_spacing(row : Int, value : Number) : self
      LibQt6.qt6cr_graphics_grid_layout_set_row_spacing(to_unsafe, row.to_i, value.to_f64)
      self
    end

    def row_spacing(row : Int) : Float64
      LibQt6.qt6cr_graphics_grid_layout_row_spacing(to_unsafe, row.to_i)
    end

    def set_column_spacing(column : Int, value : Number) : self
      LibQt6.qt6cr_graphics_grid_layout_set_column_spacing(to_unsafe, column.to_i, value.to_f64)
      self
    end

    def column_spacing(column : Int) : Float64
      LibQt6.qt6cr_graphics_grid_layout_column_spacing(to_unsafe, column.to_i)
    end

    def set_row_stretch_factor(row : Int, stretch : Int) : self
      LibQt6.qt6cr_graphics_grid_layout_set_row_stretch_factor(to_unsafe, row.to_i, stretch.to_i)
      self
    end

    def row_stretch_factor(row : Int) : Int32
      LibQt6.qt6cr_graphics_grid_layout_row_stretch_factor(to_unsafe, row.to_i)
    end

    def set_column_stretch_factor(column : Int, stretch : Int) : self
      LibQt6.qt6cr_graphics_grid_layout_set_column_stretch_factor(to_unsafe, column.to_i, stretch.to_i)
      self
    end

    def column_stretch_factor(column : Int) : Int32
      LibQt6.qt6cr_graphics_grid_layout_column_stretch_factor(to_unsafe, column.to_i)
    end

    def set_row_minimum_height(row : Int, height : Number) : self
      LibQt6.qt6cr_graphics_grid_layout_set_row_minimum_height(to_unsafe, row.to_i, height.to_f64)
      self
    end

    def row_minimum_height(row : Int) : Float64
      LibQt6.qt6cr_graphics_grid_layout_row_minimum_height(to_unsafe, row.to_i)
    end

    def set_row_preferred_height(row : Int, height : Number) : self
      LibQt6.qt6cr_graphics_grid_layout_set_row_preferred_height(to_unsafe, row.to_i, height.to_f64)
      self
    end

    def row_preferred_height(row : Int) : Float64
      LibQt6.qt6cr_graphics_grid_layout_row_preferred_height(to_unsafe, row.to_i)
    end

    def set_row_maximum_height(row : Int, height : Number) : self
      LibQt6.qt6cr_graphics_grid_layout_set_row_maximum_height(to_unsafe, row.to_i, height.to_f64)
      self
    end

    def row_maximum_height(row : Int) : Float64
      LibQt6.qt6cr_graphics_grid_layout_row_maximum_height(to_unsafe, row.to_i)
    end

    def set_row_fixed_height(row : Int, height : Number) : self
      LibQt6.qt6cr_graphics_grid_layout_set_row_fixed_height(to_unsafe, row.to_i, height.to_f64)
      self
    end

    def set_column_minimum_width(column : Int, width : Number) : self
      LibQt6.qt6cr_graphics_grid_layout_set_column_minimum_width(to_unsafe, column.to_i, width.to_f64)
      self
    end

    def column_minimum_width(column : Int) : Float64
      LibQt6.qt6cr_graphics_grid_layout_column_minimum_width(to_unsafe, column.to_i)
    end

    def set_column_preferred_width(column : Int, width : Number) : self
      LibQt6.qt6cr_graphics_grid_layout_set_column_preferred_width(to_unsafe, column.to_i, width.to_f64)
      self
    end

    def column_preferred_width(column : Int) : Float64
      LibQt6.qt6cr_graphics_grid_layout_column_preferred_width(to_unsafe, column.to_i)
    end

    def set_column_maximum_width(column : Int, width : Number) : self
      LibQt6.qt6cr_graphics_grid_layout_set_column_maximum_width(to_unsafe, column.to_i, width.to_f64)
      self
    end

    def column_maximum_width(column : Int) : Float64
      LibQt6.qt6cr_graphics_grid_layout_column_maximum_width(to_unsafe, column.to_i)
    end

    def set_column_fixed_width(column : Int, width : Number) : self
      LibQt6.qt6cr_graphics_grid_layout_set_column_fixed_width(to_unsafe, column.to_i, width.to_f64)
      self
    end

    def set_row_alignment(row : Int, alignment : AlignmentFlag) : self
      LibQt6.qt6cr_graphics_grid_layout_set_row_alignment(to_unsafe, row.to_i, alignment.value)
      self
    end

    def row_alignment(row : Int) : AlignmentFlag
      AlignmentFlag.from_value(LibQt6.qt6cr_graphics_grid_layout_row_alignment(to_unsafe, row.to_i))
    end

    def set_column_alignment(column : Int, alignment : AlignmentFlag) : self
      LibQt6.qt6cr_graphics_grid_layout_set_column_alignment(to_unsafe, column.to_i, alignment.value)
      self
    end

    def column_alignment(column : Int) : AlignmentFlag
      AlignmentFlag.from_value(LibQt6.qt6cr_graphics_grid_layout_column_alignment(to_unsafe, column.to_i))
    end

    def set_alignment(item : GraphicsWidget, alignment : AlignmentFlag) : self
      LibQt6.qt6cr_graphics_grid_layout_set_alignment(to_unsafe, item.to_unsafe, alignment.value)
      self
    end

    def alignment(item : GraphicsWidget) : AlignmentFlag
      AlignmentFlag.from_value(LibQt6.qt6cr_graphics_grid_layout_alignment(to_unsafe, item.to_unsafe))
    end

    def row_count : Int32
      LibQt6.qt6cr_graphics_grid_layout_row_count(to_unsafe)
    end

    def column_count : Int32
      LibQt6.qt6cr_graphics_grid_layout_column_count(to_unsafe)
    end

    # Returns the widget placed at the given row and column, if present.
    def item_at(row : Int, column : Int) : GraphicsWidget?
      handle = LibQt6.qt6cr_graphics_grid_layout_item_at_cell(to_unsafe, row.to_i, column.to_i)
      handle.null? ? nil : GraphicsWidget.wrap(handle)
    end

    # Removes the given widget from the layout.
    def remove_item(item : GraphicsWidget) : self
      LibQt6.qt6cr_graphics_grid_layout_remove_item(to_unsafe, item.to_unsafe)
      self
    end

    def set_spacing(value : Number) : self
      self.spacing = value
      self
    end

    def set_horizontal_spacing(value : Number) : self
      self.horizontal_spacing = value
      self
    end

    def set_vertical_spacing(value : Number) : self
      self.vertical_spacing = value
      self
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_graphics_grid_layout_destroy(to_unsafe)
    end
  end
end
