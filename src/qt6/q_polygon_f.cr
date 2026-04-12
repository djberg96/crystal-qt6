module Qt6
  # Wraps `QPolygonF` for painter polygon geometry.
  class QPolygonF < NativeResource
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(points : Enumerable(PointF) = [] of PointF)
      super(LibQt6.qt6cr_qpolygonf_create)
      points.each { |point| append(point) }
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def append(point : PointF) : self
      LibQt6.qt6cr_qpolygonf_append(to_unsafe, point.to_native)
      self
    end

    def <<(point : PointF) : self
      append(point)
    end

    def size : Int32
      LibQt6.qt6cr_qpolygonf_size(to_unsafe)
    end

    def empty? : Bool
      size.zero?
    end

    def [](index : Int) : PointF
      PointF.from_native(LibQt6.qt6cr_qpolygonf_at(to_unsafe, index.to_i32))
    end

    def bounding_rect : RectF
      RectF.from_native(LibQt6.qt6cr_qpolygonf_bounding_rect(to_unsafe))
    end

    def to_a : Array(PointF)
      Array(PointF).new(size) { |index| self[index] }
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_qpolygonf_destroy(to_unsafe)
    end
  end
end
