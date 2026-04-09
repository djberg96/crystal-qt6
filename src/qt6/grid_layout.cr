module Qt6
  class GridLayout < Layout
    def initialize(parent : Widget)
      super(LibQt6.qt6cr_grid_layout_create(parent.to_unsafe))
    end

    def add(widget : Widget, row : Int, column : Int, row_span : Int = 1, column_span : Int = 1) : Widget
      LibQt6.qt6cr_grid_layout_add_widget(@to_unsafe, widget.to_unsafe, row, column, row_span, column_span)
      adopt(widget)
    end
  end
end