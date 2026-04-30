module Qt6
  # Wraps `QPolygon` for integer-coordinate polygon geometry.
  class QPolygon < NativeResource
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(points : Enumerable(Point) = [] of Point)
      super(LibQt6.qt6cr_qpolygon_create)
      points.each { |point| append(point) }
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def append(point : Point) : self
      LibQt6.qt6cr_qpolygon_append(to_unsafe, point.to_native)
      self
    end

    def <<(point : Point) : self
      append(point)
    end

    def size : Int32
      LibQt6.qt6cr_qpolygon_size(to_unsafe)
    end

    def empty? : Bool
      size.zero?
    end

    def [](index : Int) : Point
      Point.from_native(LibQt6.qt6cr_qpolygon_at(to_unsafe, index.to_i32))
    end

    def bounding_rect : Rect
      Rect.from_native(LibQt6.qt6cr_qpolygon_bounding_rect(to_unsafe))
    end

    def to_a : Array(Point)
      Array(Point).new(size) { |index| self[index] }
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_qpolygon_destroy(to_unsafe)
    end
  end
end
