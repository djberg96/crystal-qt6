module Qt6
  # Wraps `QGraphicsEllipseItem`.
  class GraphicsEllipseItem < AbstractGraphicsShapeItem
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates an ellipse item, optionally parented to another graphics item.
    def initialize(parent : GraphicsItem? = nil)
      super(LibQt6.qt6cr_graphics_ellipse_item_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    # Creates an ellipse item with the given rectangle, optionally parented.
    def initialize(rect : RectF, parent : GraphicsItem? = nil)
      super(LibQt6.qt6cr_graphics_ellipse_item_create_with_rect(rect.to_native, parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    # Creates an ellipse item from coordinates, optionally parented.
    def initialize(x : Number, y : Number, width : Number, height : Number, parent : GraphicsItem? = nil)
      initialize(RectF.new(x.to_f64, y.to_f64, width.to_f64, height.to_f64), parent)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the ellipse rectangle.
    def rect : RectF
      RectF.from_native(LibQt6.qt6cr_graphics_ellipse_item_rect(to_unsafe))
    end

    # Sets the ellipse rectangle and returns it.
    def rect=(value : RectF) : RectF
      LibQt6.qt6cr_graphics_ellipse_item_set_rect(to_unsafe, value.to_native)
      value
    end

    # Sets the ellipse rectangle and returns `self`.
    def set_rect(value : RectF) : self
      self.rect = value
      self
    end

    # Sets the ellipse rectangle from coordinates and returns `self`.
    def set_rect(x : Number, y : Number, width : Number, height : Number) : self
      self.rect = RectF.new(x.to_f64, y.to_f64, width.to_f64, height.to_f64)
      self
    end

    # Returns the start angle in sixteenths of a degree.
    def start_angle : Int32
      LibQt6.qt6cr_graphics_ellipse_item_start_angle(to_unsafe)
    end

    # Sets the start angle and returns it.
    def start_angle=(value : Int) : Int32
      angle = value.to_i
      LibQt6.qt6cr_graphics_ellipse_item_set_start_angle(to_unsafe, angle)
      angle
    end

    # Returns the span angle in sixteenths of a degree.
    def span_angle : Int32
      LibQt6.qt6cr_graphics_ellipse_item_span_angle(to_unsafe)
    end

    # Sets the span angle and returns it.
    def span_angle=(value : Int) : Int32
      angle = value.to_i
      LibQt6.qt6cr_graphics_ellipse_item_set_span_angle(to_unsafe, angle)
      angle
    end

    # Returns the ellipse item's bounding rectangle.
    def bounding_rect : RectF
      RectF.from_native(LibQt6.qt6cr_graphics_ellipse_item_bounding_rect(to_unsafe))
    end

    # Returns `true` when the point falls inside the ellipse shape.
    def contains?(point : PointF) : Bool
      LibQt6.qt6cr_graphics_ellipse_item_contains(to_unsafe, point.to_native)
    end
  end
end
