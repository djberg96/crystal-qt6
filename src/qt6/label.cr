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
  end
end
