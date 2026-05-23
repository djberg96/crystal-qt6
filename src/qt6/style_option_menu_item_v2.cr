module Qt6
  # Wraps `QStyleOptionMenuItemV2` for Qt 6 menu-item paint extensions.
  class StyleOptionMenuItemV2 < StyleOptionMenuItem
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize
      super(LibQt6.qt6cr_style_option_menu_item_v2_create, true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def mouse_down? : Bool
      LibQt6.qt6cr_style_option_menu_item_v2_is_mouse_down(to_unsafe)
    end

    def mouse_down=(value : Bool) : Bool
      LibQt6.qt6cr_style_option_menu_item_v2_set_mouse_down(to_unsafe, value)
      value
    end

    def set_mouse_down(value : Bool) : self
      self.mouse_down = value
      self
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_style_option_menu_item_v2_destroy(to_unsafe)
    end
  end
end
