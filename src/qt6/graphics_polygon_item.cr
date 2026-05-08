module Qt6
  # Wraps `QGraphicsPolygonItem`.
  class GraphicsPolygonItem < AbstractGraphicsShapeItem
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a polygon item, optionally parented to another graphics item.
    def initialize(parent : GraphicsItem? = nil)
      super(LibQt6.qt6cr_graphics_polygon_item_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    # Creates a polygon item with the given polygon, optionally parented.
    def initialize(polygon : QPolygonF, parent : GraphicsItem? = nil)
      super(LibQt6.qt6cr_graphics_polygon_item_create_with_polygon(polygon.to_unsafe, parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the current polygon.
    def polygon : QPolygonF
      QPolygonF.wrap(LibQt6.qt6cr_graphics_polygon_item_polygon(to_unsafe), true)
    end

    # Sets the polygon and returns it.
    def polygon=(value : QPolygonF) : QPolygonF
      LibQt6.qt6cr_graphics_polygon_item_set_polygon(to_unsafe, value.to_unsafe)
      value
    end

    # Qt-style alias for `polygon=`.
    def set_polygon(value : QPolygonF) : self
      self.polygon = value
      self
    end

    # Returns the fill rule used for the polygon shape.
    def fill_rule : FillRule
      FillRule.from_value(LibQt6.qt6cr_graphics_polygon_item_fill_rule(to_unsafe))
    end

    # Sets the fill rule and returns it.
    def fill_rule=(value : FillRule) : FillRule
      LibQt6.qt6cr_graphics_polygon_item_set_fill_rule(to_unsafe, value.value)
      value
    end

    # Qt-style alias for `fill_rule=`.
    def set_fill_rule(value : FillRule) : self
      self.fill_rule = value
      self
    end

    # Returns the polygon item's bounding rectangle.
    def bounding_rect : RectF
      RectF.from_native(LibQt6.qt6cr_graphics_polygon_item_bounding_rect(to_unsafe))
    end

    # Returns `true` when the point falls inside the polygon shape.
    def contains?(point : PointF) : Bool
      LibQt6.qt6cr_graphics_polygon_item_contains(to_unsafe, point.to_native)
    end
  end
end
