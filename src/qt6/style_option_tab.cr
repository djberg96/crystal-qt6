module Qt6
  # Wraps `QStyleOptionTab` for tab paint and layout state.
  class StyleOptionTab < StyleOption
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize
      super(LibQt6.qt6cr_style_option_tab_create, true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def shape : TabBarShape
      TabBarShape.from_value(LibQt6.qt6cr_style_option_tab_shape(to_unsafe))
    end

    def shape=(value : TabBarShape) : TabBarShape
      LibQt6.qt6cr_style_option_tab_set_shape(to_unsafe, value.value)
      value
    end

    def text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_style_option_tab_text(to_unsafe))
    end

    def text=(value : String) : String
      LibQt6.qt6cr_style_option_tab_set_text(to_unsafe, value.to_unsafe)
      value
    end

    def icon : QIcon
      QIcon.wrap(LibQt6.qt6cr_style_option_tab_icon(to_unsafe), true)
    end

    def icon=(value : QIcon) : QIcon
      LibQt6.qt6cr_style_option_tab_set_icon(to_unsafe, value.to_unsafe)
      value
    end

    def row : Int32
      LibQt6.qt6cr_style_option_tab_row(to_unsafe)
    end

    def row=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_style_option_tab_set_row(to_unsafe, int_value)
      int_value
    end

    def position : StyleOptionTabPosition
      StyleOptionTabPosition.from_value(LibQt6.qt6cr_style_option_tab_position(to_unsafe))
    end

    def position=(value : StyleOptionTabPosition) : StyleOptionTabPosition
      LibQt6.qt6cr_style_option_tab_set_position(to_unsafe, value.value)
      value
    end

    def selected_position : StyleOptionTabSelectedPosition
      StyleOptionTabSelectedPosition.from_value(LibQt6.qt6cr_style_option_tab_selected_position(to_unsafe))
    end

    def selected_position=(value : StyleOptionTabSelectedPosition) : StyleOptionTabSelectedPosition
      LibQt6.qt6cr_style_option_tab_set_selected_position(to_unsafe, value.value)
      value
    end

    def corner_widgets : StyleOptionTabCornerWidget
      StyleOptionTabCornerWidget.from_value(LibQt6.qt6cr_style_option_tab_corner_widgets(to_unsafe))
    end

    def corner_widgets=(value : StyleOptionTabCornerWidget) : StyleOptionTabCornerWidget
      LibQt6.qt6cr_style_option_tab_set_corner_widgets(to_unsafe, value.value)
      value
    end

    def icon_size : Size
      Size.from_native(LibQt6.qt6cr_style_option_tab_icon_size(to_unsafe))
    end

    def icon_size=(value : Size) : Size
      LibQt6.qt6cr_style_option_tab_set_icon_size(
        to_unsafe,
        LibQt6::SizeValue.new(width: value.width, height: value.height)
      )
      value
    end

    def document_mode? : Bool
      LibQt6.qt6cr_style_option_tab_document_mode(to_unsafe)
    end

    def document_mode=(value : Bool) : Bool
      LibQt6.qt6cr_style_option_tab_set_document_mode(to_unsafe, value)
      value
    end

    def left_button_size : Size
      Size.from_native(LibQt6.qt6cr_style_option_tab_left_button_size(to_unsafe))
    end

    def left_button_size=(value : Size) : Size
      LibQt6.qt6cr_style_option_tab_set_left_button_size(
        to_unsafe,
        LibQt6::SizeValue.new(width: value.width, height: value.height)
      )
      value
    end

    def right_button_size : Size
      Size.from_native(LibQt6.qt6cr_style_option_tab_right_button_size(to_unsafe))
    end

    def right_button_size=(value : Size) : Size
      LibQt6.qt6cr_style_option_tab_set_right_button_size(
        to_unsafe,
        LibQt6::SizeValue.new(width: value.width, height: value.height)
      )
      value
    end

    def features : StyleOptionTabFeature
      StyleOptionTabFeature.from_value(LibQt6.qt6cr_style_option_tab_features(to_unsafe))
    end

    def features=(value : StyleOptionTabFeature) : StyleOptionTabFeature
      LibQt6.qt6cr_style_option_tab_set_features(to_unsafe, value.value)
      value
    end

    def tab_index : Int32
      LibQt6.qt6cr_style_option_tab_index(to_unsafe)
    end

    def tab_index=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_style_option_tab_set_tab_index(to_unsafe, int_value)
      int_value
    end

    def init_from(tab_bar : TabBar, tab_index : Int) : self
      LibQt6.qt6cr_style_option_init_from(to_unsafe, tab_bar.to_unsafe)
      LibQt6.qt6cr_tab_bar_init_style_option(tab_bar.to_unsafe, tab_index.to_i32, to_unsafe)
      self
    end

    def set_shape(value : TabBarShape) : self
      self.shape = value
      self
    end

    def set_text(value : String) : self
      self.text = value
      self
    end

    def set_icon(value : QIcon) : self
      self.icon = value
      self
    end

    def set_row(value : Int) : self
      self.row = value
      self
    end

    def set_position(value : StyleOptionTabPosition) : self
      self.position = value
      self
    end

    def set_selected_position(value : StyleOptionTabSelectedPosition) : self
      self.selected_position = value
      self
    end

    def set_corner_widgets(value : StyleOptionTabCornerWidget) : self
      self.corner_widgets = value
      self
    end

    def set_icon_size(value : Size) : self
      self.icon_size = value
      self
    end

    def set_document_mode(value : Bool) : self
      self.document_mode = value
      self
    end

    def set_left_button_size(value : Size) : self
      self.left_button_size = value
      self
    end

    def set_right_button_size(value : Size) : self
      self.right_button_size = value
      self
    end

    def set_features(value : StyleOptionTabFeature) : self
      self.features = value
      self
    end

    def set_tab_index(value : Int) : self
      self.tab_index = value
      self
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_style_option_tab_destroy(to_unsafe)
    end
  end
end
