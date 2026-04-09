module Qt6
  class LineEdit < Widget
    def initialize(text : String = "", parent : Widget? = nil)
      super(LibQt6.qt6cr_line_edit_create(parent.try(&.to_unsafe) || Pointer(Void).null, text.to_unsafe), parent.nil?)
    end

    def text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_line_edit_text(to_unsafe))
    end

    def text=(value : String) : String
      LibQt6.qt6cr_line_edit_set_text(to_unsafe, value.to_unsafe)
      value
    end
  end
end
