module Qt6
  # Wraps `QFont` for text styling.
  class QFont < NativeResource
    # Creates a font with optional family, size, bold, and italic settings.
    def initialize(family : String = "", point_size : Int = -1, bold : Bool = false, italic : Bool = false)
      super(LibQt6.qt6cr_qfont_create(family.to_unsafe, point_size, bold, italic))
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the font family name.
    def family : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_qfont_family(to_unsafe))
    end

    # Sets the font family name.
    def family=(value : String) : String
      LibQt6.qt6cr_qfont_set_family(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the point size.
    def point_size : Int32
      LibQt6.qt6cr_qfont_point_size(to_unsafe)
    end

    # Sets the point size.
    def point_size=(value : Int) : Int32
      point_size = value.to_i32
      LibQt6.qt6cr_qfont_set_point_size(to_unsafe, point_size)
      point_size
    end

    # Returns `true` if the font is bold.
    def bold? : Bool
      LibQt6.qt6cr_qfont_bold(to_unsafe)
    end

    # Enables or disables bold text.
    def bold=(value : Bool) : Bool
      LibQt6.qt6cr_qfont_set_bold(to_unsafe, value)
      value
    end

    # Returns `true` if the font is italic.
    def italic? : Bool
      LibQt6.qt6cr_qfont_italic(to_unsafe)
    end

    # Enables or disables italic text.
    def italic=(value : Bool) : Bool
      LibQt6.qt6cr_qfont_set_italic(to_unsafe, value)
      value
    end

    # Returns font metrics for measuring text with this font.
    def metrics : QFontMetrics
      QFontMetrics.new(self)
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_qfont_destroy(to_unsafe)
    end
  end
end