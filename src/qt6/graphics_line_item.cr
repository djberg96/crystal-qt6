module Qt6
  # Wraps `QGraphicsLineItem`.
  class GraphicsLineItem < GraphicsItem
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a line item, optionally parented to another graphics item.
    def initialize(parent : GraphicsItem? = nil)
      super(LibQt6.qt6cr_graphics_line_item_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    # Creates a line item with the given line, optionally parented.
    def initialize(line : LineF, parent : GraphicsItem? = nil)
      super(LibQt6.qt6cr_graphics_line_item_create_with_line(line.to_native, parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    # Creates a line item from coordinates, optionally parented.
    def initialize(x1 : Number, y1 : Number, x2 : Number, y2 : Number, parent : GraphicsItem? = nil)
      initialize(LineF.new(x1, y1, x2, y2), parent)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the stroke pen.
    def pen : QPen
      QPen.wrap(LibQt6.qt6cr_graphics_line_item_pen(to_unsafe), true)
    end

    # Sets the stroke pen and returns it.
    def pen=(value : QPen) : QPen
      LibQt6.qt6cr_graphics_line_item_set_pen(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the line geometry.
    def line : LineF
      LineF.from_native(LibQt6.qt6cr_graphics_line_item_line(to_unsafe))
    end

    # Sets the line geometry and returns it.
    def line=(value : LineF) : LineF
      LibQt6.qt6cr_graphics_line_item_set_line(to_unsafe, value.to_native)
      value
    end

    # Sets the line geometry and returns `self`.
    def set_line(value : LineF) : self
      self.line = value
      self
    end

    # Sets the line geometry from coordinates and returns `self`.
    def set_line(x1 : Number, y1 : Number, x2 : Number, y2 : Number) : self
      self.line = LineF.new(x1, y1, x2, y2)
      self
    end

    # Returns the line item's bounding rectangle.
    def bounding_rect : RectF
      RectF.from_native(LibQt6.qt6cr_graphics_line_item_bounding_rect(to_unsafe))
    end

    # Returns `true` when the point falls inside the stroked line shape.
    def contains?(point : PointF) : Bool
      LibQt6.qt6cr_graphics_line_item_contains(to_unsafe, point.to_native)
    end

    # Returns `true` when the given item obscures this line item.
    def obscured_by?(item : GraphicsItem) : Bool
      LibQt6.qt6cr_graphics_line_item_is_obscured_by(to_unsafe, item.to_unsafe)
    end

    # Returns the line item's opaque area as a painter path.
    def opaque_area : QPainterPath
      QPainterPath.wrap(LibQt6.qt6cr_graphics_line_item_opaque_area(to_unsafe), true)
    end
  end
end
