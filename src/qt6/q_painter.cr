module Qt6
  # Wraps `QPainter` for scoped drawing onto raster and export paint devices.
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

    # Begins painting on the given SVG generator.
    def initialize(target : QSvgGenerator)
      super(LibQt6.qt6cr_qpainter_create_for_svg_generator(target.to_unsafe))
    end

    # Begins painting on the given PDF writer.
    def initialize(target : QPdfWriter)
      super(LibQt6.qt6cr_qpainter_create_for_pdf_writer(target.to_unsafe))
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

    # Opens a painter for an SVG generator for the duration of the block and
    # releases it afterward.
    def self.paint(target : QSvgGenerator, &block)
      painter = new(target)
      begin
        yield painter
      ensure
        painter.release
      end
    end

    # Opens a painter for a PDF writer for the duration of the block and
    # releases it afterward.
    def self.paint(target : QPdfWriter, &block)
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

    # Enables or disables smooth pixmap filtering.
    def smooth_pixmap_transform=(value : Bool) : Bool
      LibQt6.qt6cr_qpainter_set_smooth_pixmap_transform(to_unsafe, value)
      value
    end

    # Sets the pen color used for outlines and lines.
    def pen=(color : Color) : Color
      LibQt6.qt6cr_qpainter_set_pen_color(to_unsafe, color.to_native)
      color
    end

    # Sets the pen used for outlines and lines.
    def pen=(pen : QPen) : QPen
      LibQt6.qt6cr_qpainter_set_pen(to_unsafe, pen.to_unsafe)
      pen
    end

    # Sets the brush color used for fills.
    def brush=(color : Color) : Color
      LibQt6.qt6cr_qpainter_set_brush_color(to_unsafe, color.to_native)
      color
    end

    # Sets the brush used for fills.
    def brush=(brush : QBrush) : QBrush
      LibQt6.qt6cr_qpainter_set_brush(to_unsafe, brush.to_unsafe)
      brush
    end

    # Sets the font used for subsequent text drawing.
    def font=(font : QFont) : QFont
      LibQt6.qt6cr_qpainter_set_font(to_unsafe, font.to_unsafe)
      font
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

    # Applies a translation to the current transform.
    def translate(dx : Number, dy : Number) : self
      LibQt6.qt6cr_qpainter_translate(to_unsafe, dx.to_f64, dy.to_f64)
      self
    end

    # Applies a scale to the current transform.
    def scale(sx : Number, sy : Number) : self
      LibQt6.qt6cr_qpainter_scale(to_unsafe, sx.to_f64, sy.to_f64)
      self
    end

    # Saves the current painter state.
    def save : self
      LibQt6.qt6cr_qpainter_save(to_unsafe)
      self
    end

    # Restores the most recently saved painter state.
    def restore : self
      LibQt6.qt6cr_qpainter_restore(to_unsafe)
      self
    end

    # Returns the current opacity.
    def opacity : Float64
      LibQt6.qt6cr_qpainter_opacity(to_unsafe)
    end

    # Sets the painter opacity.
    def opacity=(value : Number) : Float64
      opacity = value.to_f64
      LibQt6.qt6cr_qpainter_set_opacity(to_unsafe, opacity)
      opacity
    end

    # Returns the current composition mode.
    def composition_mode : PainterCompositionMode
      PainterCompositionMode.from_value(LibQt6.qt6cr_qpainter_composition_mode(to_unsafe))
    end

    # Sets the composition mode used for subsequent drawing.
    def composition_mode=(value : PainterCompositionMode) : PainterCompositionMode
      LibQt6.qt6cr_qpainter_set_composition_mode(to_unsafe, value.value)
      value
    end

    # Enables or disables clipping.
    def clipping=(value : Bool) : Bool
      LibQt6.qt6cr_qpainter_set_clipping(to_unsafe, value)
      value
    end

    # Replaces the current clip path.
    def clip_path=(path : QPainterPath) : QPainterPath
      LibQt6.qt6cr_qpainter_set_clip_path(to_unsafe, path.to_unsafe)
      path
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

    # Draws the outline and fill for an ellipse defined by center and radii.
    def draw_ellipse(center : PointF, rx : Number, ry : Number) : self
      LibQt6.qt6cr_qpainter_draw_ellipse_center(to_unsafe, center.to_native, rx.to_f64, ry.to_f64)
      self
    end

    # Draws a vector path.
    def draw_path(path : QPainterPath) : self
      LibQt6.qt6cr_qpainter_draw_path(to_unsafe, path.to_unsafe)
      self
    end

    # Draws a polygon.
    def draw_polygon(polygon : QPolygonF) : self
      LibQt6.qt6cr_qpainter_draw_polygon(to_unsafe, polygon.to_unsafe)
      self
    end

    # Draws an image with its top-left corner at the given position.
    def draw_image(position : PointF, image : QImage) : self
      LibQt6.qt6cr_qpainter_draw_image(to_unsafe, position.to_native, image.to_unsafe)
      self
    end

    # Draws an image with its top-left corner at the given coordinates.
    def draw_image(x : Number, y : Number, image : QImage) : self
      LibQt6.qt6cr_qpainter_draw_image_xy(to_unsafe, x.to_f64, y.to_f64, image.to_unsafe)
      self
    end

    # Draws a pixmap with its top-left corner at the given position.
    def draw_pixmap(position : PointF, pixmap : QPixmap) : self
      LibQt6.qt6cr_qpainter_draw_pixmap(to_unsafe, position.to_native, pixmap.to_unsafe)
      self
    end

    # Draws a pixmap with its top-left corner at the given coordinates.
    def draw_pixmap(x : Number, y : Number, pixmap : QPixmap) : self
      LibQt6.qt6cr_qpainter_draw_pixmap_xy(to_unsafe, x.to_f64, y.to_f64, pixmap.to_unsafe)
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
