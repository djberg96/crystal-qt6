module Qt6
  # Wraps `QLineEdit`.
  class LineEdit < Widget
    # Creates a line edit with optional starting text and parent.
    def initialize(text : String = "", parent : Widget? = nil)
      super(LibQt6.qt6cr_line_edit_create(parent.try(&.to_unsafe) || Pointer(Void).null, text.to_unsafe), parent.nil?)
    end

    # Returns the current line-edit text.
    def text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_line_edit_text(to_unsafe))
    end

    # Sets the current line-edit text and returns the assigned value.
    def text=(value : String) : String
      LibQt6.qt6cr_line_edit_set_text(to_unsafe, value.to_unsafe)
      value
    end
  end
end
