module Qt6
  # Wraps `QGraphicsPathItem`.
  class GraphicsPathItem < AbstractGraphicsShapeItem
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a path item, optionally parented to another graphics item.
    def initialize(parent : GraphicsItem? = nil)
      super(LibQt6.qt6cr_graphics_path_item_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    # Creates a path item with the given painter path, optionally parented.
    def initialize(path : QPainterPath, parent : GraphicsItem? = nil)
      super(LibQt6.qt6cr_graphics_path_item_create_with_path(path.to_unsafe, parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the current painter path.
    def path : QPainterPath
      QPainterPath.wrap(LibQt6.qt6cr_graphics_path_item_path(to_unsafe), true)
    end

    # Sets the painter path and returns it.
    def path=(value : QPainterPath) : QPainterPath
      LibQt6.qt6cr_graphics_path_item_set_path(to_unsafe, value.to_unsafe)
      value
    end

    # Qt-style alias for `path=`.
    def set_path(value : QPainterPath) : self
      self.path = value
      self
    end

    # Returns the path item's bounding rectangle.
    def bounding_rect : RectF
      RectF.from_native(LibQt6.qt6cr_graphics_path_item_bounding_rect(to_unsafe))
    end

    # Returns `true` when the point falls inside the painted path shape.
    def contains?(point : PointF) : Bool
      LibQt6.qt6cr_graphics_path_item_contains(to_unsafe, point.to_native)
    end
  end
end
