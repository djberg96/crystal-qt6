module Qt6
  # Wraps `QStyleOptionTabWidgetFrame` for tab-widget frame paint state.
  class StyleOptionTabWidgetFrame < StyleOption
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize
      super(LibQt6.qt6cr_style_option_tab_widget_frame_create, true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def line_width : Int32
      LibQt6.qt6cr_style_option_tab_widget_frame_line_width(to_unsafe)
    end

    def line_width=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_style_option_tab_widget_frame_set_line_width(to_unsafe, int_value)
      int_value
    end

    def mid_line_width : Int32
      LibQt6.qt6cr_style_option_tab_widget_frame_mid_line_width(to_unsafe)
    end

    def mid_line_width=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_style_option_tab_widget_frame_set_mid_line_width(to_unsafe, int_value)
      int_value
    end

    def shape : TabBarShape
      TabBarShape.from_value(LibQt6.qt6cr_style_option_tab_widget_frame_shape(to_unsafe))
    end

    def shape=(value : TabBarShape) : TabBarShape
      LibQt6.qt6cr_style_option_tab_widget_frame_set_shape(to_unsafe, value.value)
      value
    end

    def tab_bar_size : Size
      Size.from_native(LibQt6.qt6cr_style_option_tab_widget_frame_tab_bar_size(to_unsafe))
    end

    def tab_bar_size=(value : Size) : Size
      LibQt6.qt6cr_style_option_tab_widget_frame_set_tab_bar_size(
        to_unsafe,
        LibQt6::SizeValue.new(width: value.width, height: value.height)
      )
      value
    end

    def right_corner_widget_size : Size
      Size.from_native(LibQt6.qt6cr_style_option_tab_widget_frame_right_corner_widget_size(to_unsafe))
    end

    def right_corner_widget_size=(value : Size) : Size
      LibQt6.qt6cr_style_option_tab_widget_frame_set_right_corner_widget_size(
        to_unsafe,
        LibQt6::SizeValue.new(width: value.width, height: value.height)
      )
      value
    end

    def left_corner_widget_size : Size
      Size.from_native(LibQt6.qt6cr_style_option_tab_widget_frame_left_corner_widget_size(to_unsafe))
    end

    def left_corner_widget_size=(value : Size) : Size
      LibQt6.qt6cr_style_option_tab_widget_frame_set_left_corner_widget_size(
        to_unsafe,
        LibQt6::SizeValue.new(width: value.width, height: value.height)
      )
      value
    end

    def tab_bar_rect : RectF
      RectF.from_native(LibQt6.qt6cr_style_option_tab_widget_frame_tab_bar_rect(to_unsafe))
    end

    def tab_bar_rect=(value : Rect) : Rect
      LibQt6.qt6cr_style_option_tab_widget_frame_set_tab_bar_rect(to_unsafe, value.to_native)
      value
    end

    def tab_bar_rect=(value : RectF) : RectF
      LibQt6.qt6cr_style_option_tab_widget_frame_set_tab_bar_rect(to_unsafe, value.to_rect.to_native)
      value
    end

    def selected_tab_rect : RectF
      RectF.from_native(LibQt6.qt6cr_style_option_tab_widget_frame_selected_tab_rect(to_unsafe))
    end

    def selected_tab_rect=(value : Rect) : Rect
      LibQt6.qt6cr_style_option_tab_widget_frame_set_selected_tab_rect(to_unsafe, value.to_native)
      value
    end

    def selected_tab_rect=(value : RectF) : RectF
      LibQt6.qt6cr_style_option_tab_widget_frame_set_selected_tab_rect(to_unsafe, value.to_rect.to_native)
      value
    end

    def init_from(tab_widget : TabWidget) : self
      LibQt6.qt6cr_style_option_init_from(to_unsafe, tab_widget.to_unsafe)
      LibQt6.qt6cr_tab_widget_init_style_option(tab_widget.to_unsafe, to_unsafe)
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

    def set_shape(value : TabBarShape) : self
      self.shape = value
      self
    end

    def set_tab_bar_size(value : Size) : self
      self.tab_bar_size = value
      self
    end

    def set_right_corner_widget_size(value : Size) : self
      self.right_corner_widget_size = value
      self
    end

    def set_left_corner_widget_size(value : Size) : self
      self.left_corner_widget_size = value
      self
    end

    def set_tab_bar_rect(value : Rect | RectF) : self
      self.tab_bar_rect = value
      self
    end

    def set_selected_tab_rect(value : Rect | RectF) : self
      self.selected_tab_rect = value
      self
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_style_option_tab_widget_frame_destroy(to_unsafe)
    end
  end
end
