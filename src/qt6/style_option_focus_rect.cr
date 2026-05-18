module Qt6
  # Wraps `QStyleOptionFocusRect` for focus-indicator paint state.
  class StyleOptionFocusRect < StyleOption
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize
      super(LibQt6.qt6cr_style_option_focus_rect_create, true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def background_color : Color
      Color.from_native(LibQt6.qt6cr_style_option_focus_rect_background_color(to_unsafe))
    end

    def background_color=(value : Color) : Color
      LibQt6.qt6cr_style_option_focus_rect_set_background_color(to_unsafe, value.to_native)
      value
    end

    def set_background_color(value : Color) : self
      self.background_color = value
      self
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_style_option_focus_rect_destroy(to_unsafe)
    end
  end
end
