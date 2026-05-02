module Qt6
  # Wraps `QBoxLayout`.
  class BoxLayout < Layout
    # Creates a box layout attached to the given parent widget.
    def initialize(direction : BoxLayoutDirection, parent : Widget)
      super(LibQt6.qt6cr_box_layout_create(parent.to_unsafe, direction.value))
    end

    protected def initialize(handle : LibQt6::Handle)
      super(handle)
    end

    # Returns the current layout direction.
    def direction : BoxLayoutDirection
      BoxLayoutDirection.from_value(LibQt6.qt6cr_box_layout_direction(@to_unsafe))
    end

    # Sets the layout direction and returns it.
    def direction=(value : BoxLayoutDirection) : BoxLayoutDirection
      LibQt6.qt6cr_box_layout_set_direction(@to_unsafe, value.value)
      value
    end

    # Adds a widget to the layout and returns the widget.
    def add(widget : Widget) : Widget
      LibQt6.qt6cr_box_layout_add_widget(@to_unsafe, widget.to_unsafe)
      adopt(widget)
    end

    # Inserts a widget at the given layout index and returns it.
    def insert(index : Int, widget : Widget) : Widget
      LibQt6.qt6cr_box_layout_insert_widget(@to_unsafe, index.to_i32, widget.to_unsafe)
      adopt(widget)
    end

    # Adds fixed spacing to the layout and returns `self`.
    def add_spacing(size : Int) : self
      LibQt6.qt6cr_box_layout_add_spacing(@to_unsafe, size.to_i32)
      self
    end

    # Inserts fixed spacing at the given layout index and returns `self`.
    def insert_spacing(index : Int, size : Int) : self
      LibQt6.qt6cr_box_layout_insert_spacing(@to_unsafe, index.to_i32, size.to_i32)
      self
    end

    # Adds stretchable empty space to the layout and returns `self`.
    def add_stretch(stretch : Int = 0) : self
      LibQt6.qt6cr_box_layout_add_stretch(@to_unsafe, stretch.to_i32)
      self
    end

    # Inserts stretchable empty space and returns `self`.
    def insert_stretch(index : Int, stretch : Int = 0) : self
      LibQt6.qt6cr_box_layout_insert_stretch(@to_unsafe, index.to_i32, stretch.to_i32)
      self
    end

    # Sets the stretch factor for the item at the given index.
    def set_stretch(index : Int, stretch : Int) : self
      LibQt6.qt6cr_box_layout_set_stretch(@to_unsafe, index.to_i32, stretch.to_i32)
      self
    end

    # Appends a widget to the layout and returns `self`.
    def <<(widget : Widget) : self
      add(widget)
      self
    end
  end
end
