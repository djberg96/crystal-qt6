module Qt6
  # Wraps `QTransform` for geometric transformations applied during painting.
  class QTransform < NativeResource
    # Wraps an existing native transform handle.
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates an identity transform.
    def initialize
      super(LibQt6.qt6cr_qtransform_create)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns a copy of this transform.
    def dup : self
      self.class.wrap(LibQt6.qt6cr_qtransform_copy(to_unsafe), true)
    end

    # Resets the transform to the identity matrix.
    def reset : self
      LibQt6.qt6cr_qtransform_reset(to_unsafe)
      self
    end

    # Applies a translation to the transform.
    def translate(dx : Number, dy : Number) : self
      LibQt6.qt6cr_qtransform_translate(to_unsafe, dx.to_f64, dy.to_f64)
      self
    end

    # Applies a scale to the transform.
    def scale(sx : Number, sy : Number) : self
      LibQt6.qt6cr_qtransform_scale(to_unsafe, sx.to_f64, sy.to_f64)
      self
    end

    # Applies a clockwise rotation in degrees.
    def rotate(angle : Number) : self
      LibQt6.qt6cr_qtransform_rotate(to_unsafe, angle.to_f64)
      self
    end

    # Maps a point through the transform.
    def map(point : PointF) : PointF
      PointF.from_native(LibQt6.qt6cr_qtransform_map_point(to_unsafe, point.to_native))
    end

    # Maps a rectangle through the transform.
    def map(rect : RectF) : RectF
      RectF.from_native(LibQt6.qt6cr_qtransform_map_rect(to_unsafe, rect.to_native))
    end

    # Maps a path through the transform.
    def map(path : QPainterPath) : QPainterPath
      QPainterPath.wrap(LibQt6.qt6cr_qtransform_map_path(to_unsafe, path.to_unsafe), true)
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_qtransform_destroy(to_unsafe)
    end
  end
end
