module Qt6
  # Wraps `QStyleOptionMenuItem` for menu paint and action-row state.
  class StyleOptionMenuItem < StyleOption
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize
      super(LibQt6.qt6cr_style_option_menu_item_create, true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def menu_item_type : StyleOptionMenuItemType
      StyleOptionMenuItemType.from_value(LibQt6.qt6cr_style_option_menu_item_menu_item_type(to_unsafe))
    end

    def menu_item_type=(value : StyleOptionMenuItemType) : StyleOptionMenuItemType
      LibQt6.qt6cr_style_option_menu_item_set_menu_item_type(to_unsafe, value.value)
      value
    end

    def check_type : StyleOptionMenuItemCheckType
      StyleOptionMenuItemCheckType.from_value(LibQt6.qt6cr_style_option_menu_item_check_type(to_unsafe))
    end

    def check_type=(value : StyleOptionMenuItemCheckType) : StyleOptionMenuItemCheckType
      LibQt6.qt6cr_style_option_menu_item_set_check_type(to_unsafe, value.value)
      value
    end

    def checked? : Bool
      LibQt6.qt6cr_style_option_menu_item_is_checked(to_unsafe)
    end

    def checked=(value : Bool) : Bool
      LibQt6.qt6cr_style_option_menu_item_set_checked(to_unsafe, value)
      value
    end

    def menu_has_checkable_items? : Bool
      LibQt6.qt6cr_style_option_menu_item_menu_has_checkable_items(to_unsafe)
    end

    def menu_has_checkable_items=(value : Bool) : Bool
      LibQt6.qt6cr_style_option_menu_item_set_menu_has_checkable_items(to_unsafe, value)
      value
    end

    def menu_rect : RectF
      RectF.from_native(LibQt6.qt6cr_style_option_menu_item_menu_rect(to_unsafe))
    end

    def menu_rect=(value : Rect) : Rect
      LibQt6.qt6cr_style_option_menu_item_set_menu_rect(to_unsafe, value.to_native)
      value
    end

    def menu_rect=(value : RectF) : RectF
      LibQt6.qt6cr_style_option_menu_item_set_menu_rect(to_unsafe, value.to_rect.to_native)
      value
    end

    def text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_style_option_menu_item_text(to_unsafe))
    end

    def text=(value : String) : String
      LibQt6.qt6cr_style_option_menu_item_set_text(to_unsafe, value.to_unsafe)
      value
    end

    def icon : QIcon
      QIcon.wrap(LibQt6.qt6cr_style_option_menu_item_icon(to_unsafe), true)
    end

    def icon=(value : QIcon) : QIcon
      LibQt6.qt6cr_style_option_menu_item_set_icon(to_unsafe, value.to_unsafe)
      value
    end

    def max_icon_width : Int32
      LibQt6.qt6cr_style_option_menu_item_max_icon_width(to_unsafe)
    end

    def max_icon_width=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_style_option_menu_item_set_max_icon_width(to_unsafe, int_value)
      int_value
    end

    def reserved_shortcut_width : Int32
      LibQt6.qt6cr_style_option_menu_item_reserved_shortcut_width(to_unsafe)
    end

    def reserved_shortcut_width=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_style_option_menu_item_set_reserved_shortcut_width(to_unsafe, int_value)
      int_value
    end

    def font : QFont
      QFont.wrap(LibQt6.qt6cr_style_option_menu_item_font(to_unsafe), true)
    end

    def font=(value : QFont) : QFont
      LibQt6.qt6cr_style_option_menu_item_set_font(to_unsafe, value.to_unsafe)
      value
    end

    def init_from(menu : Menu, action : Action? = nil) : self
      LibQt6.qt6cr_style_option_init_from(to_unsafe, menu.to_unsafe)
      LibQt6.qt6cr_menu_init_style_option(menu.to_unsafe, action.try(&.to_unsafe) || Pointer(Void).null, to_unsafe)
      self
    end

    def set_menu_item_type(value : StyleOptionMenuItemType) : self
      self.menu_item_type = value
      self
    end

    def set_check_type(value : StyleOptionMenuItemCheckType) : self
      self.check_type = value
      self
    end

    def set_checked(value : Bool) : self
      self.checked = value
      self
    end

    def set_menu_has_checkable_items(value : Bool) : self
      self.menu_has_checkable_items = value
      self
    end

    def set_menu_rect(value : Rect | RectF) : self
      self.menu_rect = value
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

    def set_max_icon_width(value : Int) : self
      self.max_icon_width = value
      self
    end

    def set_reserved_shortcut_width(value : Int) : self
      self.reserved_shortcut_width = value
      self
    end

    def set_font(value : QFont) : self
      self.font = value
      self
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_style_option_menu_item_destroy(to_unsafe)
    end
  end
end
