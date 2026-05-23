module Qt6
  # Wraps `QStyleOptionToolBar` for toolbar paint and layout state.
  class StyleOptionToolBar < StyleOption
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize
      super(LibQt6.qt6cr_style_option_tool_bar_create, true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def position_of_line : StyleOptionToolBarPosition
      StyleOptionToolBarPosition.from_value(LibQt6.qt6cr_style_option_tool_bar_position_of_line(to_unsafe))
    end

    def position_of_line=(value : StyleOptionToolBarPosition) : StyleOptionToolBarPosition
      LibQt6.qt6cr_style_option_tool_bar_set_position_of_line(to_unsafe, value.value)
      value
    end

    def position_within_line : StyleOptionToolBarPosition
      StyleOptionToolBarPosition.from_value(LibQt6.qt6cr_style_option_tool_bar_position_within_line(to_unsafe))
    end

    def position_within_line=(value : StyleOptionToolBarPosition) : StyleOptionToolBarPosition
      LibQt6.qt6cr_style_option_tool_bar_set_position_within_line(to_unsafe, value.value)
      value
    end

    def tool_bar_area : ToolBarArea
      ToolBarArea.from_value(LibQt6.qt6cr_style_option_tool_bar_area(to_unsafe))
    end

    def tool_bar_area=(value : ToolBarArea) : ToolBarArea
      LibQt6.qt6cr_style_option_tool_bar_set_area(to_unsafe, value.value)
      value
    end

    def features : StyleOptionToolBarFeature
      StyleOptionToolBarFeature.from_value(LibQt6.qt6cr_style_option_tool_bar_features(to_unsafe))
    end

    def features=(value : StyleOptionToolBarFeature) : StyleOptionToolBarFeature
      LibQt6.qt6cr_style_option_tool_bar_set_features(to_unsafe, value.value)
      value
    end

    def line_width : Int32
      LibQt6.qt6cr_style_option_tool_bar_line_width(to_unsafe)
    end

    def line_width=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_style_option_tool_bar_set_line_width(to_unsafe, int_value)
      int_value
    end

    def mid_line_width : Int32
      LibQt6.qt6cr_style_option_tool_bar_mid_line_width(to_unsafe)
    end

    def mid_line_width=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_style_option_tool_bar_set_mid_line_width(to_unsafe, int_value)
      int_value
    end

    def init_from(toolbar : ToolBar) : self
      LibQt6.qt6cr_style_option_init_from(to_unsafe, toolbar.to_unsafe)
      LibQt6.qt6cr_tool_bar_init_style_option(toolbar.to_unsafe, to_unsafe)
      self
    end

    def set_position_of_line(value : StyleOptionToolBarPosition) : self
      self.position_of_line = value
      self
    end

    def set_position_within_line(value : StyleOptionToolBarPosition) : self
      self.position_within_line = value
      self
    end

    def set_tool_bar_area(value : ToolBarArea) : self
      self.tool_bar_area = value
      self
    end

    def set_features(value : StyleOptionToolBarFeature) : self
      self.features = value
      self
    end

    def set_line_width(value : Int) : self
      self.line_width = value
      self
    end

    def set_mid_line_width(value : Int) : self
      self.mid_line_width = value
      self
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_style_option_tool_bar_destroy(to_unsafe)
    end
  end
end
