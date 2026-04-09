module Qt6
  # Wraps `QPainter` for scoped drawing onto images and pixmaps.
  class QPainter < NativeResource
    # Wraps an existing native painter handle.
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Begins painting on the given image.
    def initialize(target : QImage)
      super(LibQt6.qt6cr_qpainter_create_for_image(target.to_unsafe))
    end

    # Begins painting on the given pixmap.
    def initialize(target : QPixmap)
      super(LibQt6.qt6cr_qpainter_create_for_pixmap(target.to_unsafe))
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Opens a painter for an image for the duration of the block and releases
    # it afterward.
    def self.paint(target : QImage, &block)
      painter = new(target)
      begin
        yield painter
      ensure
        painter.release
      end
    end

    # Opens a painter for a pixmap for the duration of the block and releases
    # it afterward.
    def self.paint(target : QPixmap, &block)
      painter = new(target)
      begin
        yield painter
      ensure
        painter.release
      end
    end

    # Returns `true` while the painter is actively bound to a target.
    def active? : Bool
      LibQt6.qt6cr_qpainter_is_active(to_unsafe)
    end

    # Enables or disables antialiasing.
    def antialiasing=(value : Bool) : Bool
      LibQt6.qt6cr_qpainter_set_antialiasing(to_unsafe, value)
      value
    end

    # Sets the pen color used for outlines and lines.
    def pen=(color : Color) : Color
      LibQt6.qt6cr_qpainter_set_pen_color(to_unsafe, color.to_native)
      color
    end

    # Sets the brush color used for fills.
    def brush=(color : Color) : Color
      LibQt6.qt6cr_qpainter_set_brush_color(to_unsafe, color.to_native)
      color
    end

    # Replaces the painter transform.
    def transform=(transform : QTransform) : QTransform
      LibQt6.qt6cr_qpainter_set_transform(to_unsafe, transform.to_unsafe)
      transform
    end

    # Resets the painter transform back to identity.
    def reset_transform : self
      LibQt6.qt6cr_qpainter_reset_transform(to_unsafe)
      self
    end

    # Draws a line between two points.
    def draw_line(from_point : PointF, to_point : PointF) : self
      LibQt6.qt6cr_qpainter_draw_line(to_unsafe, from_point.to_native, to_point.to_native)
      self
    end

    # Draws the outline and fill for a rectangle.
    def draw_rect(rect : RectF) : self
      LibQt6.qt6cr_qpainter_draw_rect(to_unsafe, rect.to_native)
      self
    end

    # Fills a rectangle with a solid color.
    def fill_rect(rect : RectF, color : Color) : self
      LibQt6.qt6cr_qpainter_fill_rect(to_unsafe, rect.to_native, color.to_native)
      self
    end

    # Draws the outline and fill for an ellipse.
    def draw_ellipse(rect : RectF) : self
      LibQt6.qt6cr_qpainter_draw_ellipse(to_unsafe, rect.to_native)
      self
    end

    # Draws a vector path.
    def draw_path(path : QPainterPath) : self
      LibQt6.qt6cr_qpainter_draw_path(to_unsafe, path.to_unsafe)
      self
    end

    # Draws an image with its top-left corner at the given position.
    def draw_image(position : PointF, image : QImage) : self
      LibQt6.qt6cr_qpainter_draw_image(to_unsafe, position.to_native, image.to_unsafe)
      self
    end

    # Draws a pixmap with its top-left corner at the given position.
    def draw_pixmap(position : PointF, pixmap : QPixmap) : self
      LibQt6.qt6cr_qpainter_draw_pixmap(to_unsafe, position.to_native, pixmap.to_unsafe)
      self
    end

    # Draws UTF-8 text anchored at the given position.
    def draw_text(position : PointF, text : String) : self
      LibQt6.qt6cr_qpainter_draw_text(to_unsafe, position.to_native, text.to_unsafe)
      self
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_qpainter_destroy(to_unsafe)
    end
  end
end