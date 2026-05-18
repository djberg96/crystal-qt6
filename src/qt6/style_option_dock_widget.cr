module Qt6
  # Wraps `QStyleOptionDockWidget` for dock title-bar style state.
  class StyleOptionDockWidget < StyleOption
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize
      super(LibQt6.qt6cr_style_option_dock_widget_create, true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def title : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_style_option_dock_widget_title(to_unsafe))
    end

    def title=(value : String) : String
      LibQt6.qt6cr_style_option_dock_widget_set_title(to_unsafe, value.to_unsafe)
      value
    end

    def closable? : Bool
      LibQt6.qt6cr_style_option_dock_widget_closable(to_unsafe)
    end

    def closable=(value : Bool) : Bool
      LibQt6.qt6cr_style_option_dock_widget_set_closable(to_unsafe, value)
      value
    end

    def movable? : Bool
      LibQt6.qt6cr_style_option_dock_widget_movable(to_unsafe)
    end

    def movable=(value : Bool) : Bool
      LibQt6.qt6cr_style_option_dock_widget_set_movable(to_unsafe, value)
      value
    end

    def floatable? : Bool
      LibQt6.qt6cr_style_option_dock_widget_floatable(to_unsafe)
    end

    def floatable=(value : Bool) : Bool
      LibQt6.qt6cr_style_option_dock_widget_set_floatable(to_unsafe, value)
      value
    end

    def vertical_title_bar? : Bool
      LibQt6.qt6cr_style_option_dock_widget_vertical_title_bar(to_unsafe)
    end

    def vertical_title_bar=(value : Bool) : Bool
      LibQt6.qt6cr_style_option_dock_widget_set_vertical_title_bar(to_unsafe, value)
      value
    end

    def init_from(dock_widget : DockWidget) : self
      LibQt6.qt6cr_style_option_init_from(to_unsafe, dock_widget.to_unsafe)
      LibQt6.qt6cr_dock_widget_init_style_option(dock_widget.to_unsafe, to_unsafe)
      self
    end

    def set_title(value : String) : self
      self.title = value
      self
    end

    def set_closable(value : Bool) : self
      self.closable = value
      self
    end

    def set_movable(value : Bool) : self
      self.movable = value
      self
    end

    def set_floatable(value : Bool) : self
      self.floatable = value
      self
    end

    def set_vertical_title_bar(value : Bool) : self
      self.vertical_title_bar = value
      self
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_style_option_dock_widget_destroy(to_unsafe)
    end
  end
end
