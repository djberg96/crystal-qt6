module Qt6
  # Wraps `QTextCharFormat`.
  class TextCharFormat < NativeResource
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize
      super(LibQt6.qt6cr_text_char_format_create)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the current background brush.
    def background : QBrush
      QBrush.wrap(LibQt6.qt6cr_text_char_format_background(to_unsafe), true)
    end

    # Sets the current background brush and returns it.
    def background=(value : QBrush) : QBrush
      LibQt6.qt6cr_text_char_format_set_background(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the current foreground brush.
    def foreground : QBrush
      QBrush.wrap(LibQt6.qt6cr_text_char_format_foreground(to_unsafe), true)
    end

    # Sets the current foreground brush and returns it.
    def foreground=(value : QBrush) : QBrush
      LibQt6.qt6cr_text_char_format_set_foreground(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the configured font weight.
    def font_weight : Int32
      LibQt6.qt6cr_text_char_format_font_weight(to_unsafe)
    end

    # Sets the configured font weight and returns it.
    def font_weight=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_text_char_format_set_font_weight(to_unsafe, int_value)
      int_value
    end

    # Returns `true` when italic styling is enabled.
    def font_italic? : Bool
      LibQt6.qt6cr_text_char_format_font_italic(to_unsafe)
    end

    # Enables or disables italic styling.
    def font_italic=(value : Bool) : Bool
      LibQt6.qt6cr_text_char_format_set_font_italic(to_unsafe, value)
      value
    end

    # Returns `true` when underline styling is enabled.
    def font_underline? : Bool
      LibQt6.qt6cr_text_char_format_font_underline(to_unsafe)
    end

    # Enables or disables underline styling.
    def font_underline=(value : Bool) : Bool
      LibQt6.qt6cr_text_char_format_set_font_underline(to_unsafe, value)
      value
    end

    # Returns `true` when this format should highlight the full text width.
    def full_width_selection? : Bool
      LibQt6.qt6cr_text_char_format_full_width_selection(to_unsafe)
    end

    # Enables or disables full-width selection highlighting.
    def full_width_selection=(value : Bool) : Bool
      LibQt6.qt6cr_text_char_format_set_full_width_selection(to_unsafe, value)
      value
    end

    # Qt-style alias for `background=`.
    def set_background(value : QBrush) : self
      self.background = value
      self
    end

    # Qt-style alias for `foreground=`.
    def set_foreground(value : QBrush) : self
      self.foreground = value
      self
    end

    # Qt-style alias for `font_weight=`.
    def set_font_weight(value : Int) : self
      self.font_weight = value
      self
    end

    # Qt-style alias for `font_italic=`.
    def set_font_italic(value : Bool) : self
      self.font_italic = value
      self
    end

    # Qt-style alias for `font_underline=`.
    def set_font_underline(value : Bool) : self
      self.font_underline = value
      self
    end

    # Qt-style alias for `full_width_selection=`.
    def set_full_width_selection(value : Bool) : self
      self.full_width_selection = value
      self
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_text_char_format_destroy(to_unsafe)
    end
  end
end
