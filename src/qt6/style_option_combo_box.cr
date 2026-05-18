module Qt6
  # Wraps `QStyleOptionComboBox` for combo-box paint and layout state.
  class StyleOptionComboBox < StyleOption
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize
      super(LibQt6.qt6cr_style_option_combo_box_create, true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def editable? : Bool
      LibQt6.qt6cr_style_option_combo_box_editable(to_unsafe)
    end

    def editable=(value : Bool) : Bool
      LibQt6.qt6cr_style_option_combo_box_set_editable(to_unsafe, value)
      value
    end

    def popup_rect : RectF
      RectF.from_native(LibQt6.qt6cr_style_option_combo_box_popup_rect(to_unsafe))
    end

    def popup_rect=(value : Rect) : Rect
      LibQt6.qt6cr_style_option_combo_box_set_popup_rect(to_unsafe, value.to_native)
      value
    end

    def popup_rect=(value : RectF) : RectF
      LibQt6.qt6cr_style_option_combo_box_set_popup_rect(to_unsafe, value.to_rect.to_native)
      value
    end

    def frame? : Bool
      LibQt6.qt6cr_style_option_combo_box_frame(to_unsafe)
    end

    def frame=(value : Bool) : Bool
      LibQt6.qt6cr_style_option_combo_box_set_frame(to_unsafe, value)
      value
    end

    def current_text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_style_option_combo_box_current_text(to_unsafe))
    end

    def current_text=(value : String) : String
      LibQt6.qt6cr_style_option_combo_box_set_current_text(to_unsafe, value.to_unsafe)
      value
    end

    def current_icon : QIcon
      QIcon.wrap(LibQt6.qt6cr_style_option_combo_box_current_icon(to_unsafe), true)
    end

    def current_icon=(value : QIcon) : QIcon
      LibQt6.qt6cr_style_option_combo_box_set_current_icon(to_unsafe, value.to_unsafe)
      value
    end

    def icon_size : Size
      Size.from_native(LibQt6.qt6cr_style_option_combo_box_icon_size(to_unsafe))
    end

    def icon_size=(value : Size) : Size
      LibQt6.qt6cr_style_option_combo_box_set_icon_size(
        to_unsafe,
        LibQt6::SizeValue.new(width: value.width, height: value.height)
      )
      value
    end

    def text_alignment : AlignmentFlag
      AlignmentFlag.from_value(LibQt6.qt6cr_style_option_combo_box_text_alignment(to_unsafe))
    end

    def text_alignment=(value : AlignmentFlag) : AlignmentFlag
      LibQt6.qt6cr_style_option_combo_box_set_text_alignment(to_unsafe, value.value)
      value
    end

    def set_editable(value : Bool) : self
      self.editable = value
      self
    end

    def set_popup_rect(value : Rect | RectF) : self
      self.popup_rect = value
      self
    end

    def set_frame(value : Bool) : self
      self.frame = value
      self
    end

    def set_current_text(value : String) : self
      self.current_text = value
      self
    end

    def set_current_icon(value : QIcon) : self
      self.current_icon = value
      self
    end

    def set_icon_size(value : Size) : self
      self.icon_size = value
      self
    end

    def set_text_alignment(value : AlignmentFlag) : self
      self.text_alignment = value
      self
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_style_option_combo_box_destroy(to_unsafe)
    end
  end
end
