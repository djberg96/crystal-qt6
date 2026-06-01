module Qt6
  # Wraps `QToolButton`.
  class ToolButton < AbstractButton
    @triggered_action : Signal(Action?) = Signal(Action?).new
    @triggered_userdata : LibQt6::Handle = Pointer(Void).null

    getter triggered_action : Signal(Action?)

    # Creates a tool button with an optional parent.
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_tool_button_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      register_callbacks
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      register_callbacks
    end

    private def register_callbacks : Nil
      @triggered_action = Signal(Action?).new
      @triggered_userdata = Box.box(self)
      LibQt6.qt6cr_tool_button_on_triggered(to_unsafe, TRIGGERED_ACTION_TRAMPOLINE, @triggered_userdata)
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

    # Returns the popup mode used when a menu is attached.
    def popup_mode : ToolButtonPopupMode
      ToolButtonPopupMode.from_value(LibQt6.qt6cr_tool_button_popup_mode(to_unsafe))
    end

    # Sets the popup mode used when a menu is attached.
    def popup_mode=(value : ToolButtonPopupMode) : ToolButtonPopupMode
      LibQt6.qt6cr_tool_button_set_popup_mode(to_unsafe, value.value)
      value
    end

    # Returns the decorative arrow type used by the button.
    def arrow_type : ArrowType
      ArrowType.from_value(LibQt6.qt6cr_tool_button_arrow_type(to_unsafe))
    end

    # Sets the decorative arrow type used by the button.
    def arrow_type=(value : ArrowType) : ArrowType
      LibQt6.qt6cr_tool_button_set_arrow_type(to_unsafe, value.value)
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
      value.adopt_by_parent! unless value.nil?
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

    # Returns the preferred size for the current icon/text/menu configuration.
    def size_hint : Size
      Size.from_native(LibQt6.qt6cr_tool_button_size_hint(to_unsafe))
    end

    # Returns the minimum recommended size for the current button configuration.
    def minimum_size_hint : Size
      Size.from_native(LibQt6.qt6cr_tool_button_minimum_size_hint(to_unsafe))
    end

    # Shows the attached menu, if one is assigned.
    def show_menu : self
      LibQt6.qt6cr_tool_button_show_menu(to_unsafe)
      self
    end

    def on_triggered_action(&block : Action? ->) : self
      @triggered_action.connect { |action| block.call(action) }
      self
    end

    def set_tool_button_style(value : ToolButtonStyle) : self
      self.tool_button_style = value
      self
    end

    def set_popup_mode(value : ToolButtonPopupMode) : self
      self.popup_mode = value
      self
    end

    def set_arrow_type(value : ArrowType) : self
      self.arrow_type = value
      self
    end

    def set_menu(value : Menu?) : self
      self.menu = value
      self
    end

    def set_default_action(value : Action?) : self
      self.default_action = value
      self
    end

    def set_auto_raise(value : Bool) : self
      self.auto_raise = value
      self
    end

    protected def emit_triggered_action(handle : LibQt6::Handle) : Nil
      @triggered_action.emit(handle.null? ? nil : Action.wrap(handle))
    end

    private TRIGGERED_ACTION_TRAMPOLINE = ->(userdata : Void*, handle : Void*) do
      Box(ToolButton).unbox(userdata).emit_triggered_action(handle)
    end
  end
end
