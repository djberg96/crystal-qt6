module Qt6
  # Wraps `QStyleOptionTitleBar` for title-bar paint state.
  class StyleOptionTitleBar < StyleOptionComplex
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize
      super(LibQt6.qt6cr_style_option_title_bar_create, true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_style_option_title_bar_text(to_unsafe))
    end

    def text=(value : String) : String
      LibQt6.qt6cr_style_option_title_bar_set_text(to_unsafe, value.to_unsafe)
      value
    end

    def icon : QIcon
      QIcon.wrap(LibQt6.qt6cr_style_option_title_bar_icon(to_unsafe), true)
    end

    def icon=(value : QIcon) : QIcon
      LibQt6.qt6cr_style_option_title_bar_set_icon(to_unsafe, value.to_unsafe)
      value
    end

    def title_bar_state : WindowState
      WindowState.from_value(LibQt6.qt6cr_style_option_title_bar_state(to_unsafe))
    end

    def title_bar_state=(value : WindowState) : WindowState
      LibQt6.qt6cr_style_option_title_bar_set_state(to_unsafe, value.value)
      value
    end

    def title_bar_flags : Int32
      LibQt6.qt6cr_style_option_title_bar_flags(to_unsafe)
    end

    def title_bar_flags=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_style_option_title_bar_set_flags(to_unsafe, int_value)
      int_value
    end

    def init_from(widget : Widget) : self
      LibQt6.qt6cr_style_option_init_from(to_unsafe, widget.to_unsafe)
      LibQt6.qt6cr_widget_init_title_bar_style_option(widget.to_unsafe, to_unsafe)
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

    def set_title_bar_state(value : WindowState) : self
      self.title_bar_state = value
      self
    end

    def set_title_bar_flags(value : Int) : self
      self.title_bar_flags = value
      self
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_style_option_title_bar_destroy(to_unsafe)
    end
  end
end
