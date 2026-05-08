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

    # Returns the top-level graphics item in this widget's parent chain.
    def top_level_item : GraphicsItem?
      handle = LibQt6.qt6cr_graphics_widget_top_level_item(to_unsafe)
      handle.null? ? nil : GraphicsItem.wrap(handle)
    end

    # Returns `true` when the widget is selected.
    def selected? : Bool
      LibQt6.qt6cr_graphics_widget_is_selected(to_unsafe)
    end

    # Selects or deselects the widget.
    def selected=(value : Bool) : Bool
      LibQt6.qt6cr_graphics_widget_set_selected(to_unsafe, value)
      value
    end

    # Returns `true` when the widget accepts drops.
    def accept_drops? : Bool
      LibQt6.qt6cr_graphics_widget_accept_drops(to_unsafe)
    end

    # Enables or disables drop acceptance.
    def accept_drops=(value : Bool) : Bool
      LibQt6.qt6cr_graphics_widget_set_accept_drops(to_unsafe, value)
      value
    end

    # Returns the widget's effective opacity after parent propagation.
    def effective_opacity : Float64
      LibQt6.qt6cr_graphics_widget_effective_opacity(to_unsafe)
    end

    # Returns the widget position in parent coordinates.
    def pos : PointF
      PointF.from_native(LibQt6.qt6cr_graphics_widget_pos(to_unsafe))
    end

    # Sets the widget position and returns it.
    def pos=(value : PointF) : PointF
      LibQt6.qt6cr_graphics_widget_set_pos(to_unsafe, value.to_native)
      value
    end

    # Returns the X position in parent coordinates.
    def x : Float64
      pos.x
    end

    # Sets the X position and returns it.
    def x=(value : Number) : Float64
      x = value.to_f64
      LibQt6.qt6cr_graphics_widget_set_x(to_unsafe, x)
      x
    end

    # Returns the Y position in parent coordinates.
    def y : Float64
      pos.y
    end

    # Sets the Y position and returns it.
    def y=(value : Number) : Float64
      y = value.to_f64
      LibQt6.qt6cr_graphics_widget_set_y(to_unsafe, y)
      y
    end

    # Returns the widget position in scene coordinates.
    def scene_pos : PointF
      PointF.from_native(LibQt6.qt6cr_graphics_widget_scene_pos(to_unsafe))
    end

    # Sets the widget position and returns `self`.
    def set_pos(value : PointF) : self
      self.pos = value
      self
    end

    # Sets the widget position from coordinates and returns `self`.
    def set_pos(x : Number, y : Number) : self
      self.pos = PointF.new(x.to_f64, y.to_f64)
      self
    end

    # Moves the widget by the given delta and returns `self`.
    def move_by(dx : Number, dy : Number) : self
      LibQt6.qt6cr_graphics_widget_move_by(to_unsafe, dx.to_f64, dy.to_f64)
      self
    end

    # Returns the local transform.
    def transform : QTransform
      QTransform.wrap(LibQt6.qt6cr_graphics_widget_transform(to_unsafe), true)
    end

    # Returns the widget transform in scene coordinates.
    def scene_transform : QTransform
      QTransform.wrap(LibQt6.qt6cr_graphics_widget_scene_transform(to_unsafe), true)
    end

    # Applies a new local transform and returns `self`.
    def set_transform(value : QTransform, combine : Bool = false) : self
      LibQt6.qt6cr_graphics_widget_set_transform(to_unsafe, value.to_unsafe, combine)
      self
    end

    # Clears the local transform and returns `self`.
    def reset_transform : self
      LibQt6.qt6cr_graphics_widget_reset_transform(to_unsafe)
      self
    end

    # Returns the widget rotation in degrees.
    def rotation : Float64
      LibQt6.qt6cr_graphics_widget_rotation(to_unsafe)
    end

    # Sets the widget rotation and returns it.
    def rotation=(value : Number) : Float64
      rotation = value.to_f64
      LibQt6.qt6cr_graphics_widget_set_rotation(to_unsafe, rotation)
      rotation
    end

    # Returns the widget scale factor.
    def scale : Float64
      LibQt6.qt6cr_graphics_widget_scale(to_unsafe)
    end

    # Sets the widget scale and returns it.
    def scale=(value : Number) : Float64
      scale = value.to_f64
      LibQt6.qt6cr_graphics_widget_set_scale(to_unsafe, scale)
      scale
    end

    # Returns the transform origin point.
    def transform_origin_point : PointF
      PointF.from_native(LibQt6.qt6cr_graphics_widget_transform_origin_point(to_unsafe))
    end

    # Sets the transform origin point and returns it.
    def transform_origin_point=(value : PointF) : PointF
      LibQt6.qt6cr_graphics_widget_set_transform_origin_point(to_unsafe, value.to_native)
      value
    end

    # Sets the transform origin point from coordinates and returns `self`.
    def set_transform_origin_point(x : Number, y : Number) : self
      self.transform_origin_point = PointF.new(x.to_f64, y.to_f64)
      self
    end

    # Returns the Z stacking value.
    def z_value : Float64
      LibQt6.qt6cr_graphics_widget_z_value(to_unsafe)
    end

    # Sets the Z stacking value and returns it.
    def z_value=(value : Number) : Float64
      z = value.to_f64
      LibQt6.qt6cr_graphics_widget_set_z_value(to_unsafe, z)
      z
    end

    # Returns the scene-space bounding rectangle.
    def scene_bounding_rect : RectF
      RectF.from_native(LibQt6.qt6cr_graphics_widget_scene_bounding_rect(to_unsafe))
    end

    # Returns the current widget flags.
    def flags : GraphicsItemFlag
      GraphicsItemFlag.from_value(LibQt6.qt6cr_graphics_widget_flags(to_unsafe))
    end

    # Replaces the current widget flags and returns them.
    def flags=(value : GraphicsItemFlag) : GraphicsItemFlag
      LibQt6.qt6cr_graphics_widget_set_flags(to_unsafe, value.value)
      value
    end

    # Enables or disables a single widget flag.
    def set_flag(flag : GraphicsItemFlag, enabled : Bool = true) : self
      LibQt6.qt6cr_graphics_widget_set_flag(to_unsafe, flag.value, enabled)
      self
    end

    # Returns the current cache mode.
    def cache_mode : GraphicsItemCacheMode
      GraphicsItemCacheMode.from_value(LibQt6.qt6cr_graphics_widget_cache_mode(to_unsafe))
    end

    # Sets the cache mode and returns it.
    def cache_mode=(value : GraphicsItemCacheMode) : GraphicsItemCacheMode
      LibQt6.qt6cr_graphics_widget_set_cache_mode(to_unsafe, value.value)
      value
    end

    # Returns `true` because this handle wraps a graphics widget.
    def widget? : Bool
      LibQt6.qt6cr_graphics_widget_is_widget(to_unsafe)
    end

    # Returns `true` when the widget is a graphics window.
    def window? : Bool
      LibQt6.qt6cr_graphics_widget_is_window(to_unsafe)
    end

    # Returns `true` when the widget is a panel.
    def panel? : Bool
      LibQt6.qt6cr_graphics_widget_is_panel(to_unsafe)
    end

    # Returns the layout-item contents margins.
    def contents_margins : MarginsF
      value = LibQt6.qt6cr_graphics_widget_contents_margins(to_unsafe)
      MarginsF.new(value.left, value.top, value.right, value.bottom)
    end

    # Returns the rectangle inside the current contents margins.
    def contents_rect : RectF
      RectF.from_native(LibQt6.qt6cr_graphics_widget_contents_rect(to_unsafe))
    end

    # Returns the effective size hint for the given hint type.
    def effective_size_hint(which : GraphicsLayoutItemSizeHint) : SizeF
      effective_size_hint(which, SizeF.new(-1.0, -1.0))
    end

    # Returns the effective size hint for the given hint type and constraint.
    def effective_size_hint(which : GraphicsLayoutItemSizeHint, constraint : SizeF) : SizeF
      SizeF.from_native(
        LibQt6.qt6cr_graphics_widget_effective_size_hint(
          to_unsafe,
          which.value,
          constraint.width,
          constraint.height
        )
      )
    end

    # Returns `true` when the widget contributes no visible layout geometry.
    def empty? : Bool
      LibQt6.qt6cr_graphics_widget_empty(to_unsafe)
    end

    # Returns the parent layout item, if present.
    def parent_layout_item : GraphicsLayout | GraphicsWidget | Nil
      handle = LibQt6.qt6cr_graphics_widget_parent_layout_item(to_unsafe)
      handle.null? ? nil : GraphicsLayoutItem.wrap(handle)
    end

    # Returns `true` when this layout item is itself a graphics layout.
    def graphics_layout? : Bool
      LibQt6.qt6cr_graphics_widget_is_layout(to_unsafe)
    end

    # Returns `true` when ownership currently belongs to a parent layout.
    def owned_by_layout? : Bool
      LibQt6.qt6cr_graphics_widget_owned_by_layout(to_unsafe)
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

    # Installs a graphics layout on this widget.
    def layout=(value : GraphicsLayout?) : GraphicsLayout?
      LibQt6.qt6cr_graphics_widget_set_layout(to_unsafe, value.try(&.to_unsafe) || Pointer(Void).null)
      value.try(&.adopt_by_owner!)
      value
    end

    # Returns the installed graphics layout, if present.
    def layout : GraphicsLayout?
      handle = LibQt6.qt6cr_graphics_widget_layout(to_unsafe)
      handle.null? ? nil : GraphicsLayout.wrap(handle)
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
