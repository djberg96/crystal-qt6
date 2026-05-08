module Qt6
  # Wraps `QGraphicsLinearLayout`.
  class GraphicsLinearLayout < GraphicsLayout
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a graphics linear layout with an optional parent graphics widget.
    def initialize(parent : GraphicsWidget? = nil)
      super(LibQt6.qt6cr_graphics_linear_layout_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    # Creates a graphics linear layout with the given orientation and optional parent.
    def initialize(orientation : Orientation, parent : GraphicsWidget? = nil)
      super(
        LibQt6.qt6cr_graphics_linear_layout_create_with_orientation(
          orientation.value,
          parent.try(&.to_unsafe) || Pointer(Void).null
        ),
        parent.nil?
      )
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Sets the layout orientation and returns it.
    def orientation=(value : Orientation) : Orientation
      LibQt6.qt6cr_graphics_linear_layout_set_orientation(to_unsafe, value.value)
      value
    end

    # Returns the current layout orientation.
    def orientation : Orientation
      Orientation.from_value(LibQt6.qt6cr_graphics_linear_layout_orientation(to_unsafe))
    end

    # Appends a graphics widget to the layout.
    def add_item(item : GraphicsWidget) : self
      LibQt6.qt6cr_graphics_linear_layout_insert_widget(to_unsafe, -1, item.to_unsafe)
      self
    end

    # Appends a nested graphics layout to the layout.
    def add_item(item : GraphicsLayout) : self
      LibQt6.qt6cr_graphics_linear_layout_insert_layout(to_unsafe, -1, item.to_unsafe)
      item.adopt_by_owner!
      self
    end

    # Inserts a graphics widget at the given index.
    def insert_item(index : Int, item : GraphicsWidget) : self
      LibQt6.qt6cr_graphics_linear_layout_insert_widget(to_unsafe, index.to_i, item.to_unsafe)
      self
    end

    # Inserts a nested graphics layout at the given index.
    def insert_item(index : Int, item : GraphicsLayout) : self
      LibQt6.qt6cr_graphics_linear_layout_insert_layout(to_unsafe, index.to_i, item.to_unsafe)
      item.adopt_by_owner!
      self
    end

    # Appends a stretch spacer.
    def add_stretch(stretch : Int = 1) : self
      LibQt6.qt6cr_graphics_linear_layout_insert_stretch(to_unsafe, -1, stretch.to_i)
      self
    end

    # Inserts a stretch spacer at the given index.
    def insert_stretch(index : Int, stretch : Int = 1) : self
      LibQt6.qt6cr_graphics_linear_layout_insert_stretch(to_unsafe, index.to_i, stretch.to_i)
      self
    end

    # Removes a graphics widget from the layout.
    def remove_item(item : GraphicsWidget) : self
      LibQt6.qt6cr_graphics_linear_layout_remove_widget(to_unsafe, item.to_unsafe)
      self
    end

    # Removes a nested graphics layout from the layout.
    def remove_item(item : GraphicsLayout) : self
      LibQt6.qt6cr_graphics_linear_layout_remove_layout(to_unsafe, item.to_unsafe)
      item.assume_ownership! if item.parent_layout_item.nil?
      self
    end

    # Removes the layout item at the given linear index.
    def remove_at(index : Int) : self
      item = item_at(index)
      super
      if item.is_a?(GraphicsLayout) && item.parent_layout_item.nil?
        item.assume_ownership!
      end
      self
    end

    # Sets the default spacing and returns it.
    def spacing=(value : Number) : Float64
      spacing = value.to_f64
      LibQt6.qt6cr_graphics_linear_layout_set_spacing(to_unsafe, spacing)
      spacing
    end

    # Returns the default spacing.
    def spacing : Float64
      LibQt6.qt6cr_graphics_linear_layout_spacing(to_unsafe)
    end

    # Sets the spacing after the item at the given index.
    def set_item_spacing(index : Int, value : Number) : self
      LibQt6.qt6cr_graphics_linear_layout_set_item_spacing(to_unsafe, index.to_i, value.to_f64)
      self
    end

    # Returns the spacing after the item at the given index.
    def item_spacing(index : Int) : Float64
      LibQt6.qt6cr_graphics_linear_layout_item_spacing(to_unsafe, index.to_i)
    end

    # Sets the stretch factor for a graphics widget.
    def set_stretch_factor(item : GraphicsWidget, stretch : Int) : self
      LibQt6.qt6cr_graphics_linear_layout_set_stretch_factor_for_widget(to_unsafe, item.to_unsafe, stretch.to_i)
      self
    end

    # Sets the stretch factor for a nested graphics layout.
    def set_stretch_factor(item : GraphicsLayout, stretch : Int) : self
      LibQt6.qt6cr_graphics_linear_layout_set_stretch_factor_for_layout(to_unsafe, item.to_unsafe, stretch.to_i)
      self
    end

    # Returns the stretch factor for a graphics widget.
    def stretch_factor(item : GraphicsWidget) : Int32
      LibQt6.qt6cr_graphics_linear_layout_stretch_factor_for_widget(to_unsafe, item.to_unsafe)
    end

    # Returns the stretch factor for a nested graphics layout.
    def stretch_factor(item : GraphicsLayout) : Int32
      LibQt6.qt6cr_graphics_linear_layout_stretch_factor_for_layout(to_unsafe, item.to_unsafe)
    end

    # Sets the alignment for a graphics widget.
    def set_alignment(item : GraphicsWidget, alignment : AlignmentFlag) : self
      LibQt6.qt6cr_graphics_linear_layout_set_alignment_for_widget(to_unsafe, item.to_unsafe, alignment.value)
      self
    end

    # Sets the alignment for a nested graphics layout.
    def set_alignment(item : GraphicsLayout, alignment : AlignmentFlag) : self
      LibQt6.qt6cr_graphics_linear_layout_set_alignment_for_layout(to_unsafe, item.to_unsafe, alignment.value)
      self
    end

    # Returns the alignment for a graphics widget.
    def alignment(item : GraphicsWidget) : AlignmentFlag
      AlignmentFlag.from_value(LibQt6.qt6cr_graphics_linear_layout_alignment_for_widget(to_unsafe, item.to_unsafe))
    end

    # Returns the alignment for a nested graphics layout.
    def alignment(item : GraphicsLayout) : AlignmentFlag
      AlignmentFlag.from_value(LibQt6.qt6cr_graphics_linear_layout_alignment_for_layout(to_unsafe, item.to_unsafe))
    end

    # Returns the layout item at the given index, if present.
    def item_at(index : Int) : GraphicsLayout | GraphicsWidget | Nil
      handle = LibQt6.qt6cr_graphics_linear_layout_item_at(to_unsafe, index.to_i)
      handle.null? ? nil : GraphicsLayoutItem.wrap(handle)
    end

    def set_spacing(value : Number) : self
      self.spacing = value
      self
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_graphics_linear_layout_destroy(to_unsafe)
    end
  end
end
