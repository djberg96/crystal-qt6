module Qt6
  # Wraps `QPainterPath` for vector path construction.
  class QPainterPath < NativeResource
    # Creates an empty painter path.
    def initialize
      super(LibQt6.qt6cr_qpainter_path_create)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Moves the current point without drawing a segment.
    def move_to(point : PointF) : self
      LibQt6.qt6cr_qpainter_path_move_to(to_unsafe, point.to_native)
      self
    end

    # Adds a straight line segment to the given point.
    def line_to(point : PointF) : self
      LibQt6.qt6cr_qpainter_path_line_to(to_unsafe, point.to_native)
      self
    end

    # Adds a quadratic Bezier curve.
    def quad_to(control_point : PointF, end_point : PointF) : self
      LibQt6.qt6cr_qpainter_path_quad_to(to_unsafe, control_point.to_native, end_point.to_native)
      self
    end

    # Adds a cubic Bezier curve.
    def cubic_to(control_point1 : PointF, control_point2 : PointF, end_point : PointF) : self
      LibQt6.qt6cr_qpainter_path_cubic_to(to_unsafe, control_point1.to_native, control_point2.to_native, end_point.to_native)
      self
    end

    # Adds a rectangle to the path.
    def add_rect(rect : RectF) : self
      LibQt6.qt6cr_qpainter_path_add_rect(to_unsafe, rect.to_native)
      self
    end

    # Adds an ellipse bounded by the given rectangle.
    def add_ellipse(rect : RectF) : self
      LibQt6.qt6cr_qpainter_path_add_ellipse(to_unsafe, rect.to_native)
      self
    end

    # Closes the current subpath.
    def close_subpath : self
      LibQt6.qt6cr_qpainter_path_close_subpath(to_unsafe)
      self
    end

    # Returns the path's bounding rectangle.
    def bounding_rect : RectF
      RectF.from_native(LibQt6.qt6cr_qpainter_path_bounding_rect(to_unsafe))
    end

    # Returns a transformed copy of the path.
    def transformed(transform : QTransform) : QPainterPath
      QPainterPath.new(LibQt6.qt6cr_qpainter_path_transformed(to_unsafe, transform.to_unsafe), true)
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_qpainter_path_destroy(to_unsafe)
    end
  end
end