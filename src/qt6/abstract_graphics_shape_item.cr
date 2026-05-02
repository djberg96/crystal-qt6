module Qt6
  # Wraps `QAbstractGraphicsShapeItem`.
  class AbstractGraphicsShapeItem < GraphicsItem
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a minimal concrete graphics shape item, optionally parented to another item.
    def initialize(parent : GraphicsItem? = nil)
      super(LibQt6.qt6cr_abstract_graphics_shape_item_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the stroke pen.
    def pen : QPen
      QPen.wrap(LibQt6.qt6cr_abstract_graphics_shape_item_pen(to_unsafe), true)
    end

    # Sets the stroke pen and returns it.
    def pen=(value : QPen) : QPen
      LibQt6.qt6cr_abstract_graphics_shape_item_set_pen(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the fill brush.
    def brush : QBrush
      QBrush.wrap(LibQt6.qt6cr_abstract_graphics_shape_item_brush(to_unsafe), true)
    end

    # Sets the fill brush and returns it.
    def brush=(value : QBrush) : QBrush
      LibQt6.qt6cr_abstract_graphics_shape_item_set_brush(to_unsafe, value.to_unsafe)
      value
    end

    # Returns `true` when the given item obscures this item.
    def obscured_by?(item : GraphicsItem) : Bool
      LibQt6.qt6cr_abstract_graphics_shape_item_is_obscured_by(to_unsafe, item.to_unsafe)
    end

    # Returns the item's opaque area as a painter path.
    def opaque_area : QPainterPath
      QPainterPath.wrap(LibQt6.qt6cr_abstract_graphics_shape_item_opaque_area(to_unsafe), true)
    end
  end
end
