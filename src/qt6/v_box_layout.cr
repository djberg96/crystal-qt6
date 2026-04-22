module Qt6
  # Wraps `QVBoxLayout`.
  class VBoxLayout < Layout
    # Creates a vertical layout attached to the given parent widget.
    def initialize(parent : Widget)
      super(LibQt6.qt6cr_v_box_layout_create(parent.to_unsafe))
    end

    # Adds a widget to the layout and returns the widget.
    def add(widget : Widget) : Widget
      LibQt6.qt6cr_v_box_layout_add_widget(@to_unsafe, widget.to_unsafe)
      adopt(widget)
    end

    # Adds stretchable empty space to the layout and returns `self`.
    def add_stretch(stretch : Int = 0) : self
      LibQt6.qt6cr_v_box_layout_add_stretch(@to_unsafe, stretch.to_i32)
      self
    end

    # Inserts a widget at the given layout index and returns it.
    def insert(index : Int, widget : Widget) : Widget
      LibQt6.qt6cr_v_box_layout_insert_widget(@to_unsafe, index, widget.to_unsafe)
      adopt(widget)
    end

    # Appends a widget to the layout and returns `self`.
    def <<(widget : Widget) : self
      add(widget)
      self
    end
  end
end
