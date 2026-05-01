module Qt6
  # Wraps `QRubberBand`.
  class RubberBand < Widget
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a rubber band with the given shape.
    def initialize(shape : RubberBandShape = RubberBandShape::Rectangle, parent : Widget? = nil)
      super(LibQt6.qt6cr_rubber_band_create(shape.value, parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the style hint used to draw the band.
    def shape : RubberBandShape
      RubberBandShape.from_value(LibQt6.qt6cr_rubber_band_shape(to_unsafe))
    end

    # Sets the rubber band's geometry and returns the assigned rect.
    def geometry=(value : Rect) : Rect
      LibQt6.qt6cr_rubber_band_set_geometry(to_unsafe, value.to_native)
      value
    end

    # Qt-style alias for assigning the geometry.
    def set_geometry(value : Rect) : self
      self.geometry = value
      self
    end
  end
end
