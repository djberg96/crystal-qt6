module Qt6
  # Wraps `QToolButton`.
  class ToolButton < AbstractButton
    # Creates a tool button with an optional parent.
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_tool_button_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    # Returns the current tool-button style.
    def tool_button_style : ToolButtonStyle
      ToolButtonStyle.from_value(LibQt6.qt6cr_tool_button_style(to_unsafe))
    end

    # Sets the tool-button style and returns it.
    def tool_button_style=(value : ToolButtonStyle) : ToolButtonStyle
      LibQt6.qt6cr_tool_button_set_style(to_unsafe, value.value)
      value
    end
  end
end
