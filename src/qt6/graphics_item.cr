module Qt6
  # Shared wrapper for `QGraphicsItem` handles.
  class GraphicsItem < NativeResource
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def graphics_item_handle : LibQt6::Handle
      to_unsafe
    end

    # Returns `true` when the item is visible.
    def visible? : Bool
      LibQt6.qt6cr_graphics_item_is_visible(graphics_item_handle)
    end

    # Shows or hides the item.
    def visible=(value : Bool) : Bool
      LibQt6.qt6cr_graphics_item_set_visible(graphics_item_handle, value)
      value
    end

    # Shows the item and returns `self`.
    def show : self
      self.visible = true
      self
    end

    # Hides the item and returns `self`.
    def hide : self
      self.visible = false
      self
    end

    # Returns `true` when the item is enabled.
    def enabled? : Bool
      LibQt6.qt6cr_graphics_item_is_enabled(graphics_item_handle)
    end

    # Enables or disables the item.
    def enabled=(value : Bool) : Bool
      LibQt6.qt6cr_graphics_item_set_enabled(graphics_item_handle, value)
      value
    end

    # Returns the item opacity.
    def opacity : Float64
      LibQt6.qt6cr_graphics_item_opacity(graphics_item_handle)
    end

    # Sets the item opacity and returns it.
    def opacity=(value : Number) : Float64
      opacity = value.to_f64
      LibQt6.qt6cr_graphics_item_set_opacity(graphics_item_handle, opacity)
      opacity
    end

    # Returns the parent graphics item, if present.
    def parent_item : GraphicsItem?
      handle = LibQt6.qt6cr_graphics_item_parent_item(graphics_item_handle)
      handle.null? ? nil : GraphicsItem.wrap(handle)
    end

    # Returns the top-level graphics item in this item's parent chain.
    def top_level_item : GraphicsItem?
      handle = LibQt6.qt6cr_graphics_item_top_level_item(graphics_item_handle)
      handle.null? ? nil : GraphicsItem.wrap(handle)
    end

    # Returns the item group, if present.
    def group : GraphicsItemGroup?
      handle = LibQt6.qt6cr_graphics_item_group(graphics_item_handle)
      handle.null? ? nil : GraphicsItemGroup.wrap(handle)
    end

    # Moves the item into the given group and returns it.
    def group=(value : GraphicsItemGroup?) : GraphicsItemGroup?
      LibQt6.qt6cr_graphics_item_set_group(graphics_item_handle, value.try(&.to_unsafe) || Pointer(Void).null)
      if value
        adopt_by_owner!
      elsif parent_item.nil? && group.nil?
        assume_ownership!
      end
      value
    end

    # Returns `true` when the item is selected.
    def selected? : Bool
      LibQt6.qt6cr_graphics_item_is_selected(graphics_item_handle)
    end

    # Selects or deselects the item.
    def selected=(value : Bool) : Bool
      LibQt6.qt6cr_graphics_item_set_selected(graphics_item_handle, value)
      value
    end

    # Returns `true` when the item accepts drops.
    def accept_drops? : Bool
      LibQt6.qt6cr_graphics_item_accept_drops(graphics_item_handle)
    end

    # Enables or disables drop acceptance.
    def accept_drops=(value : Bool) : Bool
      LibQt6.qt6cr_graphics_item_set_accept_drops(graphics_item_handle, value)
      value
    end

    # Returns the item's effective opacity after parent propagation.
    def effective_opacity : Float64
      LibQt6.qt6cr_graphics_item_effective_opacity(graphics_item_handle)
    end

    # Returns the item position in parent coordinates.
    def pos : PointF
      PointF.from_native(LibQt6.qt6cr_graphics_item_pos(graphics_item_handle))
    end

    # Sets the item position and returns it.
    def pos=(value : PointF) : PointF
      LibQt6.qt6cr_graphics_item_set_pos(graphics_item_handle, value.to_native)
      value
    end

    # Returns the X position in parent coordinates.
    def x : Float64
      pos.x
    end

    # Sets the X position and returns it.
    def x=(value : Number) : Float64
      x = value.to_f64
      LibQt6.qt6cr_graphics_item_set_x(graphics_item_handle, x)
      x
    end

    # Returns the Y position in parent coordinates.
    def y : Float64
      pos.y
    end

    # Sets the Y position and returns it.
    def y=(value : Number) : Float64
      y = value.to_f64
      LibQt6.qt6cr_graphics_item_set_y(graphics_item_handle, y)
      y
    end

    # Returns the item position in scene coordinates.
    def scene_pos : PointF
      PointF.from_native(LibQt6.qt6cr_graphics_item_scene_pos(graphics_item_handle))
    end

    # Sets the item position and returns `self`.
    def set_pos(value : PointF) : self
      self.pos = value
      self
    end

    # Sets the item position from coordinates and returns `self`.
    def set_pos(x : Number, y : Number) : self
      self.pos = PointF.new(x.to_f64, y.to_f64)
      self
    end

    # Moves the item by the given delta and returns `self`.
    def move_by(dx : Number, dy : Number) : self
      LibQt6.qt6cr_graphics_item_move_by(graphics_item_handle, dx.to_f64, dy.to_f64)
      self
    end

    # Returns the local transform.
    def transform : QTransform
      QTransform.wrap(LibQt6.qt6cr_graphics_item_transform(graphics_item_handle), true)
    end

    # Returns the item transform in scene coordinates.
    def scene_transform : QTransform
      QTransform.wrap(LibQt6.qt6cr_graphics_item_scene_transform(graphics_item_handle), true)
    end

    # Applies a new local transform and returns `self`.
    def set_transform(value : QTransform, combine : Bool = false) : self
      LibQt6.qt6cr_graphics_item_set_transform(graphics_item_handle, value.to_unsafe, combine)
      self
    end

    # Clears the local transform and returns `self`.
    def reset_transform : self
      LibQt6.qt6cr_graphics_item_reset_transform(graphics_item_handle)
      self
    end

    # Returns the item rotation in degrees.
    def rotation : Float64
      LibQt6.qt6cr_graphics_item_rotation(graphics_item_handle)
    end

    # Sets the item rotation and returns it.
    def rotation=(value : Number) : Float64
      rotation = value.to_f64
      LibQt6.qt6cr_graphics_item_set_rotation(graphics_item_handle, rotation)
      rotation
    end

    # Returns the item scale factor.
    def scale : Float64
      LibQt6.qt6cr_graphics_item_scale(graphics_item_handle)
    end

    # Sets the item scale and returns it.
    def scale=(value : Number) : Float64
      scale = value.to_f64
      LibQt6.qt6cr_graphics_item_set_scale(graphics_item_handle, scale)
      scale
    end

    # Returns the ordered list of graphics transforms applied after the local transform.
    def transformations : Array(GraphicsTransform)
      Qt6.copy_and_release_handles(LibQt6.qt6cr_graphics_item_transformations(graphics_item_handle)).map do |handle|
        GraphicsTransform.wrap(handle).as(GraphicsTransform)
      end
    end

    # Replaces the ordered list of graphics transforms and returns it.
    def transformations=(value : Enumerable(GraphicsTransform)) : Array(GraphicsTransform)
      transforms = value.to_a.map(&.as(GraphicsTransform))
      handles = transforms.map(&.to_unsafe)
      LibQt6.qt6cr_graphics_item_set_transformations(
        graphics_item_handle,
        handles.empty? ? Pointer(LibQt6::Handle).null : handles.to_unsafe,
        handles.size
      )
      transforms
    end

    # Returns the transform origin point.
    def transform_origin_point : PointF
      PointF.from_native(LibQt6.qt6cr_graphics_item_transform_origin_point(graphics_item_handle))
    end

    # Sets the transform origin point and returns it.
    def transform_origin_point=(value : PointF) : PointF
      LibQt6.qt6cr_graphics_item_set_transform_origin_point(graphics_item_handle, value.to_native)
      value
    end

    # Sets the transform origin point from coordinates and returns `self`.
    def set_transform_origin_point(x : Number, y : Number) : self
      self.transform_origin_point = PointF.new(x.to_f64, y.to_f64)
      self
    end

    # Returns the Z stacking value.
    def z_value : Float64
      LibQt6.qt6cr_graphics_item_z_value(graphics_item_handle)
    end

    # Sets the Z stacking value and returns it.
    def z_value=(value : Number) : Float64
      z = value.to_f64
      LibQt6.qt6cr_graphics_item_set_z_value(graphics_item_handle, z)
      z
    end

    # Returns the scene-space bounding rectangle.
    def scene_bounding_rect : RectF
      RectF.from_native(LibQt6.qt6cr_graphics_item_scene_bounding_rect(graphics_item_handle))
    end

    # Returns the current item flags.
    def flags : GraphicsItemFlag
      GraphicsItemFlag.from_value(LibQt6.qt6cr_graphics_item_flags(graphics_item_handle))
    end

    # Replaces the current item flags and returns them.
    def flags=(value : GraphicsItemFlag) : GraphicsItemFlag
      LibQt6.qt6cr_graphics_item_set_flags(graphics_item_handle, value.value)
      value
    end

    # Enables or disables a single item flag.
    def set_flag(flag : GraphicsItemFlag, enabled : Bool = true) : self
      LibQt6.qt6cr_graphics_item_set_flag(graphics_item_handle, flag.value, enabled)
      self
    end

    # Returns the current cache mode.
    def cache_mode : GraphicsItemCacheMode
      GraphicsItemCacheMode.from_value(LibQt6.qt6cr_graphics_item_cache_mode(graphics_item_handle))
    end

    # Sets the cache mode and returns it.
    def cache_mode=(value : GraphicsItemCacheMode) : GraphicsItemCacheMode
      LibQt6.qt6cr_graphics_item_set_cache_mode(graphics_item_handle, value.value)
      value
    end

    # Returns `true` when the item is a graphics widget.
    def widget? : Bool
      LibQt6.qt6cr_graphics_item_is_widget(graphics_item_handle)
    end

    # Returns `true` when the item is a graphics window.
    def window? : Bool
      LibQt6.qt6cr_graphics_item_is_window(graphics_item_handle)
    end

    # Returns `true` when the item is a panel.
    def panel? : Bool
      LibQt6.qt6cr_graphics_item_is_panel(graphics_item_handle)
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_graphics_item_destroy(graphics_item_handle)
    end
  end
end
