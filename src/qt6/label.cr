module Qt6
  # Wraps `QLabel`.
  class Label < Widget
    # Creates a label with optional text and parent.
    def initialize(text : String = "", parent : Widget? = nil)
      super(LibQt6.qt6cr_label_create(parent.try(&.to_unsafe) || Pointer(Void).null, text.to_unsafe), parent.nil?)
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

    # Returns the label alignment flags.
    def alignment : AlignmentFlag
      AlignmentFlag.from_value(LibQt6.qt6cr_label_alignment(to_unsafe))
    end

    # Sets the label alignment and returns the assigned value.
    def alignment=(value : AlignmentFlag) : AlignmentFlag
      LibQt6.qt6cr_label_set_alignment(to_unsafe, value.value)
      value
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

    # Sets or clears the label pixmap.
    def pixmap=(value : QPixmap?) : QPixmap?
      LibQt6.qt6cr_label_set_pixmap(to_unsafe, value.try(&.to_unsafe) || Pointer(Void).null)
      value
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
  end
end
