module Qt6
  # Wraps `QStyleOptionToolButton` for tool-button paint state.
  class StyleOptionToolButton < StyleOptionComplex
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize
      super(LibQt6.qt6cr_style_option_tool_button_create, true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def features : StyleOptionToolButtonFeature
      StyleOptionToolButtonFeature.from_value(LibQt6.qt6cr_style_option_tool_button_features(to_unsafe))
    end

    def features=(value : StyleOptionToolButtonFeature) : StyleOptionToolButtonFeature
      LibQt6.qt6cr_style_option_tool_button_set_features(to_unsafe, value.value)
      value
    end

    def icon : QIcon
      QIcon.wrap(LibQt6.qt6cr_style_option_tool_button_icon(to_unsafe), true)
    end

    def icon=(value : QIcon) : QIcon
      LibQt6.qt6cr_style_option_tool_button_set_icon(to_unsafe, value.to_unsafe)
      value
    end

    def icon_size : Size
      Size.from_native(LibQt6.qt6cr_style_option_tool_button_icon_size(to_unsafe))
    end

    def icon_size=(value : Size) : Size
      LibQt6.qt6cr_style_option_tool_button_set_icon_size(
        to_unsafe,
        LibQt6::SizeValue.new(width: value.width, height: value.height)
      )
      value
    end

    def text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_style_option_tool_button_text(to_unsafe))
    end

    def text=(value : String) : String
      LibQt6.qt6cr_style_option_tool_button_set_text(to_unsafe, value.to_unsafe)
      value
    end

    def arrow_type : ArrowType
      ArrowType.from_value(LibQt6.qt6cr_style_option_tool_button_arrow_type(to_unsafe))
    end

    def arrow_type=(value : ArrowType) : ArrowType
      LibQt6.qt6cr_style_option_tool_button_set_arrow_type(to_unsafe, value.value)
      value
    end

    def tool_button_style : ToolButtonStyle
      ToolButtonStyle.from_value(LibQt6.qt6cr_style_option_tool_button_style(to_unsafe))
    end

    def tool_button_style=(value : ToolButtonStyle) : ToolButtonStyle
      LibQt6.qt6cr_style_option_tool_button_set_style(to_unsafe, value.value)
      value
    end

    def pos : Point
      Point.from_native(LibQt6.qt6cr_style_option_tool_button_pos(to_unsafe))
    end

    def pos=(value : Point) : Point
      LibQt6.qt6cr_style_option_tool_button_set_pos(to_unsafe, value.to_native)
      value
    end

    def font : QFont
      QFont.wrap(LibQt6.qt6cr_style_option_tool_button_font(to_unsafe), true)
    end

    def font=(value : QFont) : QFont
      LibQt6.qt6cr_style_option_tool_button_set_font(to_unsafe, value.to_unsafe)
      value
    end

    def init_from(tool_button : ToolButton) : self
      LibQt6.qt6cr_style_option_init_from(to_unsafe, tool_button.to_unsafe)
      LibQt6.qt6cr_tool_button_init_style_option(tool_button.to_unsafe, to_unsafe)
      self
    end

    def set_features(value : StyleOptionToolButtonFeature) : self
      self.features = value
      self
    end

    def set_icon(value : QIcon) : self
      self.icon = value
      self
    end

    def set_icon_size(value : Size) : self
      self.icon_size = value
      self
    end

    def set_text(value : String) : self
      self.text = value
      self
    end

    def set_arrow_type(value : ArrowType) : self
      self.arrow_type = value
      self
    end

    def set_tool_button_style(value : ToolButtonStyle) : self
      self.tool_button_style = value
      self
    end

    def set_pos(value : Point) : self
      self.pos = value
      self
    end

    def set_font(value : QFont) : self
      self.font = value
      self
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_style_option_tool_button_destroy(to_unsafe)
    end
  end
end
