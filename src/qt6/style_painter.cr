module Qt6
  # Wraps `QStylePainter` for style-aware drawing on widgets and paint devices.
  class StylePainter < QPainter
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize
      super(LibQt6.qt6cr_style_painter_create, true)
    end

    def initialize(widget : Widget)
      super(LibQt6.qt6cr_style_painter_create, true)
      self.begin(widget)
    end

    def initialize(target : QImage, widget : Widget)
      super(LibQt6.qt6cr_style_painter_create, true)
      self.begin(target, widget)
    end

    def initialize(target : QPixmap, widget : Widget)
      super(LibQt6.qt6cr_style_painter_create, true)
      self.begin(target, widget)
    end

    def initialize(target : QSvgGenerator, widget : Widget)
      super(LibQt6.qt6cr_style_painter_create, true)
      self.begin(target, widget)
    end

    def initialize(target : QPdfWriter, widget : Widget)
      super(LibQt6.qt6cr_style_painter_create, true)
      self.begin(target, widget)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def begin(widget : Widget) : Bool
      LibQt6.qt6cr_style_painter_begin_widget(to_unsafe, widget.to_unsafe)
    end

    def begin(target : QImage, widget : Widget) : Bool
      LibQt6.qt6cr_style_painter_begin_image(to_unsafe, target.to_unsafe, widget.to_unsafe)
    end

    def begin(target : QPixmap, widget : Widget) : Bool
      LibQt6.qt6cr_style_painter_begin_pixmap(to_unsafe, target.to_unsafe, widget.to_unsafe)
    end

    def begin(target : QSvgGenerator, widget : Widget) : Bool
      LibQt6.qt6cr_style_painter_begin_svg_generator(to_unsafe, target.to_unsafe, widget.to_unsafe)
    end

    def begin(target : QPdfWriter, widget : Widget) : Bool
      LibQt6.qt6cr_style_painter_begin_pdf_writer(to_unsafe, target.to_unsafe, widget.to_unsafe)
    end

    def style : Style?
      handle = LibQt6.qt6cr_style_painter_style(to_unsafe)
      handle.null? ? nil : Style.wrap(handle)
    end

    def draw_primitive(element : StylePrimitiveElement, option : StyleOption) : self
      LibQt6.qt6cr_style_painter_draw_primitive(to_unsafe, element.value, option.to_unsafe)
      self
    end

    def draw_control(element : StyleControlElement, option : StyleOption) : self
      LibQt6.qt6cr_style_painter_draw_control(to_unsafe, element.value, option.to_unsafe)
      self
    end

    def draw_complex_control(control : StyleComplexControl, option : StyleOptionComplex) : self
      LibQt6.qt6cr_style_painter_draw_complex_control(to_unsafe, control.value, option.to_unsafe)
      self
    end

    def draw_item_text(rect : Rect | RectF, alignment : AlignmentFlag, palette : QPalette, enabled : Bool, text : String, text_role : ColorRole = ColorRole::NoRole) : self
      native_rect = rect.is_a?(Rect) ? rect.to_rect_f.to_native : rect.to_native
      LibQt6.qt6cr_style_painter_draw_item_text(to_unsafe, native_rect, alignment.value, palette.to_unsafe, enabled, text.to_unsafe, text_role.value)
      self
    end

    def draw_item_pixmap(rect : Rect | RectF, alignment : AlignmentFlag, pixmap : QPixmap) : self
      native_rect = rect.is_a?(Rect) ? rect.to_rect_f.to_native : rect.to_native
      LibQt6.qt6cr_style_painter_draw_item_pixmap(to_unsafe, native_rect, alignment.value, pixmap.to_unsafe)
      self
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_style_painter_destroy(to_unsafe)
    end
  end
end
