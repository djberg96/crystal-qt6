module Qt6
  # Wraps `QGraphicsPixmapItem`.
  class GraphicsPixmapItem < GraphicsItem
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a pixmap item, optionally parented to another graphics item.
    def initialize(parent : GraphicsItem? = nil)
      super(LibQt6.qt6cr_graphics_pixmap_item_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    # Creates a pixmap item with the given pixmap, optionally parented.
    def initialize(pixmap : QPixmap, parent : GraphicsItem? = nil)
      super(LibQt6.qt6cr_graphics_pixmap_item_create_with_pixmap(pixmap.to_unsafe, parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the current pixmap.
    def pixmap : QPixmap
      QPixmap.wrap(LibQt6.qt6cr_graphics_pixmap_item_pixmap(to_unsafe), true)
    end

    # Sets the pixmap and returns it.
    def pixmap=(value : QPixmap) : QPixmap
      LibQt6.qt6cr_graphics_pixmap_item_set_pixmap(to_unsafe, value.to_unsafe)
      value
    end

    # Qt-style alias for `pixmap=`.
    def set_pixmap(value : QPixmap) : self
      self.pixmap = value
      self
    end

    # Returns the transformation quality used when scaling the pixmap.
    def transformation_mode : TransformationMode
      TransformationMode.from_value(LibQt6.qt6cr_graphics_pixmap_item_transformation_mode(to_unsafe))
    end

    # Sets the transformation quality and returns it.
    def transformation_mode=(value : TransformationMode) : TransformationMode
      LibQt6.qt6cr_graphics_pixmap_item_set_transformation_mode(to_unsafe, value.value)
      value
    end

    # Qt-style alias for `transformation_mode=`.
    def set_transformation_mode(value : TransformationMode) : self
      self.transformation_mode = value
      self
    end

    # Returns the pixmap offset within item coordinates.
    def offset : PointF
      PointF.from_native(LibQt6.qt6cr_graphics_pixmap_item_offset(to_unsafe))
    end

    # Sets the pixmap offset and returns it.
    def offset=(value : PointF) : PointF
      LibQt6.qt6cr_graphics_pixmap_item_set_offset(to_unsafe, value.to_native)
      value
    end

    # Qt-style alias for assigning the offset.
    def set_offset(value : PointF) : self
      self.offset = value
      self
    end

    # Qt-style overload for assigning the offset from coordinates.
    def set_offset(x : Number, y : Number) : self
      self.offset = PointF.new(x.to_f64, y.to_f64)
      self
    end

    # Returns the pixmap item's bounding rectangle.
    def bounding_rect : RectF
      RectF.from_native(LibQt6.qt6cr_graphics_pixmap_item_bounding_rect(to_unsafe))
    end

    # Returns `true` when the point falls inside the pixmap item's shape.
    def contains?(point : PointF) : Bool
      LibQt6.qt6cr_graphics_pixmap_item_contains(to_unsafe, point.to_native)
    end

    # Returns `true` when the given item obscures this pixmap item.
    def obscured_by?(item : GraphicsItem) : Bool
      LibQt6.qt6cr_graphics_pixmap_item_is_obscured_by(to_unsafe, item.to_unsafe)
    end

    # Returns the pixmap item's opaque area as a painter path.
    def opaque_area : QPainterPath
      QPainterPath.wrap(LibQt6.qt6cr_graphics_pixmap_item_opaque_area(to_unsafe), true)
    end

    # Returns the shape-calculation mode.
    def shape_mode : GraphicsPixmapItemShapeMode
      GraphicsPixmapItemShapeMode.from_value(LibQt6.qt6cr_graphics_pixmap_item_shape_mode(to_unsafe))
    end

    # Sets the shape-calculation mode and returns it.
    def shape_mode=(value : GraphicsPixmapItemShapeMode) : GraphicsPixmapItemShapeMode
      LibQt6.qt6cr_graphics_pixmap_item_set_shape_mode(to_unsafe, value.value)
      value
    end

    # Qt-style alias for `shape_mode=`.
    def set_shape_mode(value : GraphicsPixmapItemShapeMode) : self
      self.shape_mode = value
      self
    end
  end
end
