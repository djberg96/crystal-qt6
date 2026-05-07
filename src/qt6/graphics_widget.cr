module Qt6
  # Wraps `QGraphicsWidget` as a layout-capable graphics item.
  class GraphicsWidget < GraphicsItem
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a graphics widget with an optional parent item.
    def initialize(parent : GraphicsWidget? = nil)
      super(LibQt6.qt6cr_graphics_widget_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns `true` when the widget is visible.
    def visible? : Bool
      LibQt6.qt6cr_graphics_widget_is_visible(to_unsafe)
    end

    # Shows or hides the widget.
    def visible=(value : Bool) : Bool
      LibQt6.qt6cr_graphics_widget_set_visible(to_unsafe, value)
      value
    end

    # Returns `true` when the widget is enabled.
    def enabled? : Bool
      LibQt6.qt6cr_graphics_widget_is_enabled(to_unsafe)
    end

    # Enables or disables the widget.
    def enabled=(value : Bool) : Bool
      LibQt6.qt6cr_graphics_widget_set_enabled(to_unsafe, value)
      value
    end

    # Returns the widget opacity.
    def opacity : Float64
      LibQt6.qt6cr_graphics_widget_opacity(to_unsafe)
    end

    # Sets the widget opacity and returns it.
    def opacity=(value : Number) : Float64
      opacity = value.to_f64
      LibQt6.qt6cr_graphics_widget_set_opacity(to_unsafe, opacity)
      opacity
    end

    # Returns the parent graphics item, if present.
    def parent_item : GraphicsItem?
      handle = LibQt6.qt6cr_graphics_widget_parent_item(to_unsafe)
      handle.null? ? nil : GraphicsItem.wrap(handle)
    end

    # Installs an anchor layout on this widget.
    def layout=(value : GraphicsAnchorLayout?) : GraphicsAnchorLayout?
      LibQt6.qt6cr_graphics_widget_set_layout(to_unsafe, value.try(&.to_unsafe) || Pointer(Void).null)
      value.try(&.adopt_by_owner!)
      value
    end

    # Returns the installed anchor layout, if present.
    def layout : GraphicsAnchorLayout?
      handle = LibQt6.qt6cr_graphics_widget_layout(to_unsafe)
      handle.null? ? nil : GraphicsAnchorLayout.wrap(handle)
    end

    # Resizes the graphics widget and returns `self`.
    def resize(width : Number, height : Number) : self
      LibQt6.qt6cr_graphics_widget_resize(to_unsafe, width.to_f64, height.to_f64)
      self
    end

    # Returns the current widget size.
    def size : SizeF
      SizeF.from_native(LibQt6.qt6cr_graphics_widget_size(to_unsafe))
    end

    # Sets the preferred size and returns `self`.
    def set_preferred_size(width : Number, height : Number) : self
      LibQt6.qt6cr_graphics_widget_set_preferred_size(to_unsafe, width.to_f64, height.to_f64)
      self
    end

    # Returns the preferred size.
    def preferred_size : SizeF
      SizeF.from_native(LibQt6.qt6cr_graphics_widget_preferred_size(to_unsafe))
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_graphics_widget_destroy(to_unsafe)
    end
  end
end
