module Qt6
  # Wraps `QFontMetrics` for text measurement.
  class QFontMetrics < NativeResource
    # Creates metrics for the given font.
    def initialize(font : QFont)
      super(LibQt6.qt6cr_qfont_metrics_create(font.to_unsafe))
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the full line height.
    def height : Int32
      LibQt6.qt6cr_qfont_metrics_height(to_unsafe)
    end

    # Returns the ascent above the baseline.
    def ascent : Int32
      LibQt6.qt6cr_qfont_metrics_ascent(to_unsafe)
    end

    # Returns the descent below the baseline.
    def descent : Int32
      LibQt6.qt6cr_qfont_metrics_descent(to_unsafe)
    end

    # Returns the horizontal advance of a string.
    def horizontal_advance(text : String) : Int32
      LibQt6.qt6cr_qfont_metrics_horizontal_advance(to_unsafe, text.to_unsafe)
    end

    # Returns the bounding rectangle for a string.
    def bounding_rect(text : String) : RectF
      RectF.from_native(LibQt6.qt6cr_qfont_metrics_bounding_rect(to_unsafe, text.to_unsafe))
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_qfont_metrics_destroy(to_unsafe)
    end
  end
end