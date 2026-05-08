module Qt6
  # Wraps `QGraphicsProxyWidget`.
  class GraphicsProxyWidget < GraphicsWidget
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a proxy widget, optionally parented to another graphics item.
    def initialize(parent : GraphicsWidget? = nil)
      super(LibQt6.qt6cr_graphics_proxy_widget_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    # Creates a proxy widget and immediately embeds the given widget.
    def initialize(widget : Widget, parent : GraphicsWidget? = nil)
      initialize(parent)
      self.widget = widget
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the embedded widget, if one is installed.
    def widget : Widget?
      handle = LibQt6.qt6cr_graphics_proxy_widget_widget(to_unsafe)
      handle.null? ? nil : Widget.wrap(handle)
    end

    # Installs or clears the embedded widget.
    def widget=(value : Widget?) : Widget?
      LibQt6.qt6cr_graphics_proxy_widget_set_widget(to_unsafe, value.try(&.to_unsafe) || Pointer(Void).null)
      value.try(&.adopt_by_parent!)
      value
    end

    # Qt-style alias for `widget=`.
    def set_widget(value : Widget?) : self
      self.widget = value
      self
    end

    # Returns the embedded scene-space rectangle for the given child widget.
    def sub_widget_rect(widget : Widget) : RectF
      RectF.from_native(LibQt6.qt6cr_graphics_proxy_widget_sub_widget_rect(to_unsafe, widget.to_unsafe))
    end

    # Creates a child proxy for the given descendant widget when Qt supports it.
    def create_proxy_for_child_widget(child : Widget) : GraphicsProxyWidget?
      handle = LibQt6.qt6cr_graphics_proxy_widget_create_proxy_for_child_widget(to_unsafe, child.to_unsafe)
      return nil if handle.null?

      proxy = GraphicsProxyWidget.wrap(handle)
      proxy.adopt_by_owner!
      proxy
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_graphics_proxy_widget_destroy(to_unsafe)
    end
  end
end
