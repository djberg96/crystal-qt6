module Qt6
  # Wraps `QGraphicsRectItem`.
  class GraphicsRectItem < AbstractGraphicsShapeItem
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a rectangle item, optionally parented to another graphics item.
    def initialize(parent : GraphicsItem? = nil)
      super(LibQt6.qt6cr_graphics_rect_item_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    # Creates a rectangle item with the given rectangle, optionally parented.
    def initialize(rect : RectF, parent : GraphicsItem? = nil)
      super(LibQt6.qt6cr_graphics_rect_item_create_with_rect(rect.to_native, parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    # Creates a rectangle item from coordinates, optionally parented.
    def initialize(x : Number, y : Number, width : Number, height : Number, parent : GraphicsItem? = nil)
      initialize(RectF.new(x.to_f64, y.to_f64, width.to_f64, height.to_f64), parent)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the rectangle geometry.
    def rect : RectF
      RectF.from_native(LibQt6.qt6cr_graphics_rect_item_rect(to_unsafe))
    end

    # Sets the rectangle geometry and returns it.
    def rect=(value : RectF) : RectF
      LibQt6.qt6cr_graphics_rect_item_set_rect(to_unsafe, value.to_native)
      value
    end

    # Qt-style alias for `rect=`.
    def set_rect(value : RectF) : self
      self.rect = value
      self
    end

    # Qt-style overload for assigning the rectangle from coordinates.
    def set_rect(x : Number, y : Number, width : Number, height : Number) : self
      self.rect = RectF.new(x.to_f64, y.to_f64, width.to_f64, height.to_f64)
      self
    end

    # Returns the rectangle item's bounding rectangle.
    def bounding_rect : RectF
      RectF.from_native(LibQt6.qt6cr_graphics_rect_item_bounding_rect(to_unsafe))
    end

    # Returns `true` when the point falls inside the painted rectangle shape.
    def contains?(point : PointF) : Bool
      LibQt6.qt6cr_graphics_rect_item_contains(to_unsafe, point.to_native)
    end
  end
end
