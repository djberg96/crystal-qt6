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

    # Returns the menu shown by the tool button, if one is assigned.
    def menu : Menu?
      handle = LibQt6.qt6cr_tool_button_menu(to_unsafe)
      handle.null? ? nil : Menu.wrap(handle)
    end

    # Sets the tool-button menu and returns it.
    def menu=(value : Menu?) : Menu?
      LibQt6.qt6cr_tool_button_set_menu(to_unsafe, value.try(&.to_unsafe) || Pointer(Void).null)
      value
    end

    # Returns the default action, if present.
    def default_action : Action?
      handle = LibQt6.qt6cr_tool_button_default_action(to_unsafe)
      handle.null? ? nil : Action.wrap(handle)
    end

    # Sets the default action and returns it.
    def default_action=(value : Action?) : Action?
      LibQt6.qt6cr_tool_button_set_default_action(to_unsafe, value.try(&.to_unsafe) || Pointer(Void).null)
      value
    end

    # Returns `true` when the button draws with auto-raise styling.
    def auto_raise? : Bool
      LibQt6.qt6cr_tool_button_auto_raise(to_unsafe)
    end

    # Enables or disables auto-raise styling.
    def auto_raise=(value : Bool) : Bool
      LibQt6.qt6cr_tool_button_set_auto_raise(to_unsafe, value)
      value
    end
  end
end
