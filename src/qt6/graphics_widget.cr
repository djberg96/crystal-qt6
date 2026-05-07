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

    # Returns the widget font.
    def font : QFont
      QFont.wrap(LibQt6.qt6cr_graphics_widget_font(to_unsafe), true)
    end

    # Sets the widget font.
    def font=(value : QFont) : QFont
      LibQt6.qt6cr_graphics_widget_set_font(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the widget palette.
    def palette : QPalette
      QPalette.wrap(LibQt6.qt6cr_graphics_widget_palette(to_unsafe), true)
    end

    # Sets the widget palette.
    def palette=(value : QPalette) : QPalette
      LibQt6.qt6cr_graphics_widget_set_palette(to_unsafe, value.to_unsafe)
      value
    end

    # Returns `true` when the widget auto-fills its background.
    def auto_fill_background? : Bool
      LibQt6.qt6cr_graphics_widget_auto_fill_background(to_unsafe)
    end

    # Enables or disables background auto-fill.
    def auto_fill_background=(value : Bool) : Bool
      LibQt6.qt6cr_graphics_widget_set_auto_fill_background(to_unsafe, value)
      value
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

    # Returns the widget geometry.
    def geometry : RectF
      RectF.from_native(LibQt6.qt6cr_graphics_widget_geometry(to_unsafe))
    end

    # Sets the widget geometry and returns it.
    def geometry=(value : RectF) : RectF
      LibQt6.qt6cr_graphics_widget_set_geometry(to_unsafe, value.to_native)
      value
    end

    # Sets the widget geometry and returns `self`.
    def set_geometry(value : RectF) : self
      self.geometry = value
      self
    end

    # Sets the widget geometry from coordinates and returns `self`.
    def set_geometry(x : Number, y : Number, width : Number, height : Number) : self
      self.geometry = RectF.new(x.to_f64, y.to_f64, width.to_f64, height.to_f64)
      self
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

    # Returns the widget's horizontal size policy.
    def horizontal_size_policy : SizePolicy
      SizePolicy.from_value(LibQt6.qt6cr_graphics_widget_horizontal_size_policy(to_unsafe))
    end

    # Returns the widget's vertical size policy.
    def vertical_size_policy : SizePolicy
      SizePolicy.from_value(LibQt6.qt6cr_graphics_widget_vertical_size_policy(to_unsafe))
    end

    # Sets both size policies and returns `self`.
    def set_size_policy(horizontal : SizePolicy, vertical : SizePolicy) : self
      LibQt6.qt6cr_graphics_widget_set_size_policy(to_unsafe, horizontal.value, vertical.value)
      self
    end

    # Returns the widget's minimum size.
    def minimum_size : SizeF
      SizeF.from_native(LibQt6.qt6cr_graphics_widget_minimum_size(to_unsafe))
    end

    # Sets the minimum size and returns `self`.
    def set_minimum_size(width : Number, height : Number) : self
      LibQt6.qt6cr_graphics_widget_set_minimum_size(to_unsafe, width.to_f64, height.to_f64)
      self
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

    # Returns the widget's maximum size.
    def maximum_size : SizeF
      SizeF.from_native(LibQt6.qt6cr_graphics_widget_maximum_size(to_unsafe))
    end

    # Sets the maximum size and returns `self`.
    def set_maximum_size(width : Number, height : Number) : self
      LibQt6.qt6cr_graphics_widget_set_maximum_size(to_unsafe, width.to_f64, height.to_f64)
      self
    end

    # Recomputes the widget size from its layout hints and returns `self`.
    def adjust_size : self
      LibQt6.qt6cr_graphics_widget_adjust_size(to_unsafe)
      self
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_graphics_widget_destroy(to_unsafe)
    end
  end
end
