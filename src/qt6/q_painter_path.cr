module Qt6
  # Element kinds returned from `QPainterPath#element_at`.
  enum PainterPathElementType
    Invalid     = -1
    MoveTo      =  0
    LineTo      =  1
    CurveTo     =  2
    CurveToData =  3
  end

  # A copied `QPainterPath` element.
  record PainterPathElement, x : Float64, y : Float64, type : PainterPathElementType do
    def self.from_native(value : LibQt6::PainterPathElementValue) : self
      new(value.x, value.y, PainterPathElementType.from_value(value.type))
    end

    def point : PointF
      PointF.new(x, y)
    end
  end

  # Wraps `QPainterPath` for vector path construction.
  class QPainterPath < NativeResource
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates an empty painter path.
    def initialize
      super(LibQt6.qt6cr_qpainter_path_create)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Removes all elements from the path.
    def clear : self
      LibQt6.qt6cr_qpainter_path_clear(to_unsafe)
      self
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

    # Adds a polygon to the path.
    def add_polygon(polygon : QPolygonF) : self
      LibQt6.qt6cr_qpainter_path_add_polygon(to_unsafe, polygon.to_unsafe)
      self
    end

    # Adds another path as a separate subpath.
    def add_path(path : QPainterPath) : self
      LibQt6.qt6cr_qpainter_path_add_path(to_unsafe, path.to_unsafe)
      self
    end

    # Connects this path to another path with a line segment when needed.
    def connect_path(path : QPainterPath) : self
      LibQt6.qt6cr_qpainter_path_connect_path(to_unsafe, path.to_unsafe)
      self
    end

    # Closes the current subpath.
    def close_subpath : self
      LibQt6.qt6cr_qpainter_path_close_subpath(to_unsafe)
      self
    end

    # Returns the current drawing position.
    def current_position : PointF
      PointF.from_native(LibQt6.qt6cr_qpainter_path_current_position(to_unsafe))
    end

    # Returns the number of path elements.
    def element_count : Int32
      LibQt6.qt6cr_qpainter_path_element_count(to_unsafe)
    end

    # Returns the copied path element at the given index.
    def element_at(index : Int) : PainterPathElement
      PainterPathElement.from_native(LibQt6.qt6cr_qpainter_path_element_at(to_unsafe, index.to_i32))
    end

    # Returns the copied path element at the given index.
    def [](index : Int) : PainterPathElement
      element_at(index)
    end

    # Returns the path's bounding rectangle.
    def bounding_rect : RectF
      RectF.from_native(LibQt6.qt6cr_qpainter_path_bounding_rect(to_unsafe))
    end

    # Returns the rectangle containing all points and curve control points.
    def control_point_rect : RectF
      RectF.from_native(LibQt6.qt6cr_qpainter_path_control_point_rect(to_unsafe))
    end

    # Returns a transformed copy of the path.
    def transformed(transform : QTransform) : QPainterPath
      QPainterPath.wrap(LibQt6.qt6cr_qpainter_path_transformed(to_unsafe, transform.to_unsafe), true)
    end

    # Returns a translated copy of the path.
    def translated(dx : Number, dy : Number) : QPainterPath
      QPainterPath.wrap(LibQt6.qt6cr_qpainter_path_translated(to_unsafe, dx.to_f64, dy.to_f64), true)
    end

    # Returns a simplified copy of the path.
    def simplified : QPainterPath
      QPainterPath.wrap(LibQt6.qt6cr_qpainter_path_simplified(to_unsafe), true)
    end

    # Returns `true` if the path contains the given point.
    def contains(point : PointF) : Bool
      LibQt6.qt6cr_qpainter_path_contains(to_unsafe, point.to_native)
    end

    # Returns `true` if the path fully contains the given rectangle.
    def contains(rect : RectF) : Bool
      LibQt6.qt6cr_qpainter_path_contains_rect(to_unsafe, rect.to_native)
    end

    # Returns `true` if the path intersects the given rectangle.
    def intersects?(rect : RectF) : Bool
      LibQt6.qt6cr_qpainter_path_intersects_rect(to_unsafe, rect.to_native)
    end

    # Returns `true` if the path has no elements.
    def empty? : Bool
      LibQt6.qt6cr_qpainter_path_is_empty(to_unsafe)
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_qpainter_path_destroy(to_unsafe)
    end
  end
end
