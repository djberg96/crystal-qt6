module Qt6
  # Wraps `QGraphicsAnchorLayout`.
  class GraphicsAnchorLayout < GraphicsLayout
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates an anchor layout with an optional parent graphics widget.
    def initialize(parent : GraphicsWidget? = nil)
      super(LibQt6.qt6cr_graphics_anchor_layout_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Adds an anchor between two graphics widgets.
    def add_anchor(first_item : GraphicsWidget, first_edge : AnchorPoint, second_item : GraphicsWidget, second_edge : AnchorPoint) : GraphicsAnchor
      GraphicsAnchor.wrap(
        LibQt6.qt6cr_graphics_anchor_layout_add_anchor(
          to_unsafe,
          first_item.to_unsafe,
          first_edge.value,
          second_item.to_unsafe,
          second_edge.value
        )
      )
    end

    # Returns an existing anchor between two graphics widgets, if present.
    def anchor(first_item : GraphicsWidget, first_edge : AnchorPoint, second_item : GraphicsWidget, second_edge : AnchorPoint) : GraphicsAnchor?
      handle = LibQt6.qt6cr_graphics_anchor_layout_anchor(
        to_unsafe,
        first_item.to_unsafe,
        first_edge.value,
        second_item.to_unsafe,
        second_edge.value
      )
      handle.null? ? nil : GraphicsAnchor.wrap(handle)
    end

    # Adds a pair of corner anchors between two graphics widgets.
    def add_corner_anchors(first_item : GraphicsWidget, first_corner : Corner, second_item : GraphicsWidget, second_corner : Corner) : self
      LibQt6.qt6cr_graphics_anchor_layout_add_corner_anchors(
        to_unsafe,
        first_item.to_unsafe,
        first_corner.value,
        second_item.to_unsafe,
        second_corner.value
      )
      self
    end

    # Sets both horizontal and vertical spacing.
    def spacing=(value : Number) : Float64
      spacing = value.to_f64
      LibQt6.qt6cr_graphics_anchor_layout_set_spacing(to_unsafe, spacing)
      spacing
    end

    # Sets the horizontal spacing.
    def horizontal_spacing=(value : Number) : Float64
      spacing = value.to_f64
      LibQt6.qt6cr_graphics_anchor_layout_set_horizontal_spacing(to_unsafe, spacing)
      spacing
    end

    # Sets the vertical spacing.
    def vertical_spacing=(value : Number) : Float64
      spacing = value.to_f64
      LibQt6.qt6cr_graphics_anchor_layout_set_vertical_spacing(to_unsafe, spacing)
      spacing
    end

    # Returns the horizontal spacing.
    def horizontal_spacing : Float64
      LibQt6.qt6cr_graphics_anchor_layout_horizontal_spacing(to_unsafe)
    end

    # Returns the vertical spacing.
    def vertical_spacing : Float64
      LibQt6.qt6cr_graphics_anchor_layout_vertical_spacing(to_unsafe)
    end

    # Qt-style alias for `spacing=`.
    def set_spacing(value : Number) : self
      self.spacing = value
      self
    end

    # Qt-style alias for `horizontal_spacing=`.
    def set_horizontal_spacing(value : Number) : self
      self.horizontal_spacing = value
      self
    end

    # Qt-style alias for `vertical_spacing=`.
    def set_vertical_spacing(value : Number) : self
      self.vertical_spacing = value
      self
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_graphics_anchor_layout_destroy(to_unsafe)
    end
  end
end
