module Qt6
  # Wraps `QLabel`.
  class Label < Widget
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a label with optional text and parent.
    def initialize(text : String = "", parent : Widget? = nil)
      super(LibQt6.qt6cr_label_create(parent.try(&.to_unsafe) || Pointer(Void).null, text.to_unsafe), parent.nil?)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the label text.
    def text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_label_text(to_unsafe))
    end

    # Sets the label text and returns the assigned value.
    def text=(value : String) : String
      LibQt6.qt6cr_label_set_text(to_unsafe, value.to_unsafe)
      value
    end

    # Qt-style alias for `text=`.
    def set_text(value : String) : self
      self.text = value
      self
    end

    # Returns the label alignment flags.
    def alignment : AlignmentFlag
      AlignmentFlag.from_value(LibQt6.qt6cr_label_alignment(to_unsafe))
    end

    # Sets the label alignment and returns the assigned value.
    def alignment=(value : AlignmentFlag) : AlignmentFlag
      LibQt6.qt6cr_label_set_alignment(to_unsafe, value.value)
      value
    end

    # Qt-style alias for `alignment=`.
    def set_alignment(value : AlignmentFlag) : self
      self.alignment = value
      self
    end

    # Returns `true` when the label wraps text across multiple lines.
    def word_wrap? : Bool
      LibQt6.qt6cr_label_word_wrap(to_unsafe)
    end

    # Enables or disables word wrapping.
    def word_wrap=(value : Bool) : Bool
      LibQt6.qt6cr_label_set_word_wrap(to_unsafe, value)
      value
    end

    # Qt-style alias for `word_wrap=`.
    def set_word_wrap(value : Bool) : self
      self.word_wrap = value
      self
    end

    # Returns the current label pixmap, if any.
    def pixmap : QPixmap?
      handle = LibQt6.qt6cr_label_pixmap(to_unsafe)
      handle.null? ? nil : QPixmap.wrap(handle, true)
    end

    # Sets or clears the label pixmap without clearing the current text.
    def pixmap=(value : QPixmap?) : QPixmap?
      LibQt6.qt6cr_label_set_pixmap(to_unsafe, value.try(&.to_unsafe) || Pointer(Void).null)
      value
    end

    # Qt-style alias for `pixmap=`.
    def set_pixmap(value : QPixmap?) : self
      self.pixmap = value
      self
    end

    # Returns the text indent in pixels.
    def indent : Int32
      LibQt6.qt6cr_label_indent(to_unsafe)
    end

    # Sets the text indent in pixels.
    def indent=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_label_set_indent(to_unsafe, int_value)
      int_value
    end

    # Qt-style alias for `indent=`.
    def set_indent(value : Int) : self
      self.indent = value
      self
    end

    # Returns the content margin in pixels.
    def margin : Int32
      LibQt6.qt6cr_label_margin(to_unsafe)
    end

    # Sets the content margin in pixels.
    def margin=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_label_set_margin(to_unsafe, int_value)
      int_value
    end

    # Qt-style alias for `margin=`.
    def set_margin(value : Int) : self
      self.margin = value
      self
    end

    # Returns whether pixmap contents are scaled to the label size.
    def scaled_contents? : Bool
      LibQt6.qt6cr_label_has_scaled_contents(to_unsafe)
    end

    # Enables or disables pixmap scaling to the label size.
    def scaled_contents=(value : Bool) : Bool
      LibQt6.qt6cr_label_set_scaled_contents(to_unsafe, value)
      value
    end

    # Qt-style alias for `scaled_contents=`.
    def set_scaled_contents(value : Bool) : self
      self.scaled_contents = value
      self
    end

    # Returns the widget activated when the label mnemonic is used, if any.
    def buddy : Widget?
      handle = LibQt6.qt6cr_label_buddy(to_unsafe)
      handle.null? ? nil : Widget.wrap(handle)
    end

    # Sets or clears the mnemonic buddy widget.
    def buddy=(value : Widget?) : Widget?
      LibQt6.qt6cr_label_set_buddy(to_unsafe, value.try(&.to_unsafe) || Pointer(Void).null)
      value
    end

    # Qt-style alias for `buddy=`.
    def set_buddy(value : Widget?) : self
      self.buddy = value
      self
    end
  end
end
