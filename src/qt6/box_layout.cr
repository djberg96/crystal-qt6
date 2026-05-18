module Qt6
  # Wraps `QBoxLayout`.
  class BoxLayout < Layout
    # Creates a box layout attached to the given parent widget.
    def initialize(direction : BoxLayoutDirection, parent : Widget? = nil)
      super(LibQt6.qt6cr_box_layout_create(parent.try(&.to_unsafe) || Pointer(Void).null, direction.value))
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
    def add(widget : Widget, stretch : Int = 0) : Widget
      LibQt6.qt6cr_box_layout_add_widget(@to_unsafe, widget.to_unsafe, stretch.to_i32)
      adopt(widget)
    end

    # Adds a child layout and returns it.
    def add(layout : Layout, stretch : Int = 0) : Layout
      LibQt6.qt6cr_box_layout_add_layout(@to_unsafe, layout.to_unsafe, stretch.to_i32)
      layout.adopt_by_parent!
      layout
    end

    # Adds a spacer item to the layout and returns it.
    def add(item : SpacerItem) : SpacerItem
      LibQt6.qt6cr_box_layout_add_spacer_item(@to_unsafe, item.to_unsafe)
      item.adopt_by_owner!
      item
    end

    # Inserts a widget at the given layout index and returns it.
    def insert(index : Int, widget : Widget, stretch : Int = 0) : Widget
      LibQt6.qt6cr_box_layout_insert_widget(@to_unsafe, index.to_i32, widget.to_unsafe, stretch.to_i32)
      adopt(widget)
    end

    # Inserts a child layout at the given layout index and returns it.
    def insert(index : Int, layout : Layout, stretch : Int = 0) : Layout
      LibQt6.qt6cr_box_layout_insert_layout(@to_unsafe, index.to_i32, layout.to_unsafe, stretch.to_i32)
      layout.adopt_by_parent!
      layout
    end

    # Inserts a spacer item at the given layout index and returns it.
    def insert(index : Int, item : SpacerItem) : SpacerItem
      LibQt6.qt6cr_box_layout_insert_spacer_item(@to_unsafe, index.to_i32, item.to_unsafe)
      item.adopt_by_owner!
      item
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

    # Returns the stretch factor for the item at the given index.
    def stretch(index : Int) : Int32
      LibQt6.qt6cr_box_layout_stretch(@to_unsafe, index.to_i32)
    end

    # Sets the stretch factor for the given child widget.
    def set_stretch_factor(widget : Widget, stretch : Int) : Bool
      LibQt6.qt6cr_box_layout_set_stretch_factor_widget(@to_unsafe, widget.to_unsafe, stretch.to_i32)
    end

    # Sets the stretch factor for the given child layout.
    def set_stretch_factor(layout : Layout, stretch : Int) : Bool
      LibQt6.qt6cr_box_layout_set_stretch_factor_layout(@to_unsafe, layout.to_unsafe, stretch.to_i32)
    end

    # Adds a non-expanding minimum size in the perpendicular direction.
    def add_strut(size : Int) : self
      LibQt6.qt6cr_box_layout_add_strut(@to_unsafe, size.to_i32)
      self
    end

    # Appends a widget to the layout and returns `self`.
    def <<(widget : Widget) : self
      add(widget)
      self
    end
  end
end
