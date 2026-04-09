module Qt6
  # Wraps `QFontMetricsF` for floating-point text measurement.
  class QFontMetricsF < NativeResource
    # Creates floating-point metrics for the given font.
    def initialize(font : QFont)
      super(LibQt6.qt6cr_qfont_metrics_f_create(font.to_unsafe))
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the full line height.
    def height : Float64
      LibQt6.qt6cr_qfont_metrics_f_height(to_unsafe)
    end

    # Returns the ascent above the baseline.
    def ascent : Float64
      LibQt6.qt6cr_qfont_metrics_f_ascent(to_unsafe)
    end

    # Returns the descent below the baseline.
    def descent : Float64
      LibQt6.qt6cr_qfont_metrics_f_descent(to_unsafe)
    end

    # Returns the horizontal advance of a string.
    def horizontal_advance(text : String) : Float64
      LibQt6.qt6cr_qfont_metrics_f_horizontal_advance(to_unsafe, text.to_unsafe)
    end

    # Returns the bounding rectangle for a string.
    def bounding_rect(text : String) : RectF
      RectF.from_native(LibQt6.qt6cr_qfont_metrics_f_bounding_rect(to_unsafe, text.to_unsafe))
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_qfont_metrics_f_destroy(to_unsafe)
    end
  end
end