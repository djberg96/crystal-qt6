module Qt6
  # Wraps `QStyleOptionViewItem` for item-view paint and layout state.
  class StyleOptionViewItem < StyleOption
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize
      super(LibQt6.qt6cr_style_option_view_item_create, true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def text_rect : RectF
      RectF.from_native(LibQt6.qt6cr_style_option_view_item_text_rect(to_unsafe))
    end

    def display_alignment : AlignmentFlag
      AlignmentFlag.from_value(LibQt6.qt6cr_style_option_view_item_display_alignment(to_unsafe))
    end

    def display_alignment=(value : AlignmentFlag) : AlignmentFlag
      LibQt6.qt6cr_style_option_view_item_set_display_alignment(to_unsafe, value.value)
      value
    end

    def decoration_alignment : AlignmentFlag
      AlignmentFlag.from_value(LibQt6.qt6cr_style_option_view_item_decoration_alignment(to_unsafe))
    end

    def decoration_alignment=(value : AlignmentFlag) : AlignmentFlag
      LibQt6.qt6cr_style_option_view_item_set_decoration_alignment(to_unsafe, value.value)
      value
    end

    def text_elide_mode : TextElideMode
      TextElideMode.from_value(LibQt6.qt6cr_style_option_view_item_text_elide_mode(to_unsafe))
    end

    def text_elide_mode=(value : TextElideMode) : TextElideMode
      LibQt6.qt6cr_style_option_view_item_set_text_elide_mode(to_unsafe, value.value)
      value
    end

    def decoration_position : StyleOptionViewItemPosition
      StyleOptionViewItemPosition.from_value(LibQt6.qt6cr_style_option_view_item_decoration_position(to_unsafe))
    end

    def decoration_position=(value : StyleOptionViewItemPosition) : StyleOptionViewItemPosition
      LibQt6.qt6cr_style_option_view_item_set_decoration_position(to_unsafe, value.value)
      value
    end

    def decoration_size : Size
      Size.from_native(LibQt6.qt6cr_style_option_view_item_decoration_size(to_unsafe))
    end

    def decoration_size=(value : Size) : Size
      LibQt6.qt6cr_style_option_view_item_set_decoration_size(
        to_unsafe,
        LibQt6::SizeValue.new(width: value.width, height: value.height)
      )
      value
    end

    def font : QFont
      QFont.wrap(LibQt6.qt6cr_style_option_view_item_font(to_unsafe), true)
    end

    def font=(value : QFont) : QFont
      LibQt6.qt6cr_style_option_view_item_set_font(to_unsafe, value.to_unsafe)
      value
    end

    def show_decoration_selected? : Bool
      LibQt6.qt6cr_style_option_view_item_show_decoration_selected(to_unsafe)
    end

    def show_decoration_selected=(value : Bool) : Bool
      LibQt6.qt6cr_style_option_view_item_set_show_decoration_selected(to_unsafe, value)
      value
    end

    def features : StyleOptionViewItemFeature
      StyleOptionViewItemFeature.from_value(LibQt6.qt6cr_style_option_view_item_features(to_unsafe))
    end

    def features=(value : StyleOptionViewItemFeature) : StyleOptionViewItemFeature
      LibQt6.qt6cr_style_option_view_item_set_features(to_unsafe, value.value)
      value
    end

    def widget : Widget?
      handle = LibQt6.qt6cr_style_option_view_item_widget(to_unsafe)
      handle.null? ? nil : Widget.wrap(handle)
    end

    def widget=(value : Widget?) : Widget?
      LibQt6.qt6cr_style_option_view_item_set_widget(to_unsafe, value.try(&.to_unsafe) || Pointer(Void).null)
      value
    end

    def index : ModelIndex
      ModelIndex.wrap(LibQt6.qt6cr_style_option_view_item_index(to_unsafe), true)
    end

    def index=(value : ModelIndex) : ModelIndex
      LibQt6.qt6cr_style_option_view_item_set_index(to_unsafe, value.to_unsafe)
      value
    end

    def check_state : CheckState
      CheckState.from_value(LibQt6.qt6cr_style_option_view_item_check_state(to_unsafe))
    end

    def check_state=(value : CheckState) : CheckState
      LibQt6.qt6cr_style_option_view_item_set_check_state(to_unsafe, value.value)
      value
    end

    def icon : QIcon
      QIcon.wrap(LibQt6.qt6cr_style_option_view_item_icon(to_unsafe), true)
    end

    def icon=(value : QIcon) : QIcon
      LibQt6.qt6cr_style_option_view_item_set_icon(to_unsafe, value.to_unsafe)
      value
    end

    def text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_style_option_view_item_text(to_unsafe))
    end

    def text=(value : String) : String
      LibQt6.qt6cr_style_option_view_item_set_text(to_unsafe, value.to_unsafe)
      value
    end

    def view_item_position : StyleOptionViewItemViewPosition
      StyleOptionViewItemViewPosition.from_value(LibQt6.qt6cr_style_option_view_item_view_item_position(to_unsafe))
    end

    def view_item_position=(value : StyleOptionViewItemViewPosition) : StyleOptionViewItemViewPosition
      LibQt6.qt6cr_style_option_view_item_set_view_item_position(to_unsafe, value.value)
      value
    end

    def background_brush : QBrush
      QBrush.wrap(LibQt6.qt6cr_style_option_view_item_background_brush(to_unsafe), true)
    end

    def background_brush=(value : QBrush) : QBrush
      LibQt6.qt6cr_style_option_view_item_set_background_brush(to_unsafe, value.to_unsafe)
      value
    end

    def selected? : Bool
      LibQt6.qt6cr_style_option_view_item_selected(to_unsafe)
    end

    def enabled? : Bool
      LibQt6.qt6cr_style_option_view_item_enabled(to_unsafe)
    end

    def draw_background(painter : QPainter) : self
      LibQt6.qt6cr_style_option_view_item_draw_background(to_unsafe, painter.to_unsafe)
      self
    end

    def draw_decoration(painter : QPainter) : self
      LibQt6.qt6cr_style_option_view_item_draw_decoration(to_unsafe, painter.to_unsafe)
      self
    end

    def set_display_alignment(value : AlignmentFlag) : self
      self.display_alignment = value
      self
    end

    def set_decoration_alignment(value : AlignmentFlag) : self
      self.decoration_alignment = value
      self
    end

    def set_text_elide_mode(value : TextElideMode) : self
      self.text_elide_mode = value
      self
    end

    def set_decoration_position(value : StyleOptionViewItemPosition) : self
      self.decoration_position = value
      self
    end

    def set_decoration_size(value : Size) : self
      self.decoration_size = value
      self
    end

    def set_font(value : QFont) : self
      self.font = value
      self
    end

    def set_show_decoration_selected(value : Bool) : self
      self.show_decoration_selected = value
      self
    end

    def set_features(value : StyleOptionViewItemFeature) : self
      self.features = value
      self
    end

    def set_widget(value : Widget?) : self
      self.widget = value
      self
    end

    def set_index(value : ModelIndex) : self
      self.index = value
      self
    end

    def set_check_state(value : CheckState) : self
      self.check_state = value
      self
    end

    def set_icon(value : QIcon) : self
      self.icon = value
      self
    end

    def set_text(value : String) : self
      self.text = value
      self
    end

    def set_view_item_position(value : StyleOptionViewItemViewPosition) : self
      self.view_item_position = value
      self
    end

    def set_background_brush(value : QBrush) : self
      self.background_brush = value
      self
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_style_option_view_item_destroy(to_unsafe)
    end
  end
end
