module Qt6
  # Wraps `QGraphicsView` for scene viewport configuration and transforms.
  class GraphicsView < AbstractScrollArea
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a graphics view with an optional parent.
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_graphics_view_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the background brush used behind scene contents.
    def background_brush : QBrush
      QBrush.wrap(LibQt6.qt6cr_graphics_view_background_brush(to_unsafe), true)
    end

    # Sets the background brush.
    def background_brush=(value : QBrush) : QBrush
      LibQt6.qt6cr_graphics_view_set_background_brush(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the foreground brush painted over scene contents.
    def foreground_brush : QBrush
      QBrush.wrap(LibQt6.qt6cr_graphics_view_foreground_brush(to_unsafe), true)
    end

    # Sets the foreground brush.
    def foreground_brush=(value : QBrush) : QBrush
      LibQt6.qt6cr_graphics_view_set_foreground_brush(to_unsafe, value.to_unsafe)
      value
    end

    # Returns `true` when the view forwards input to scene items.
    def interactive? : Bool
      LibQt6.qt6cr_graphics_view_is_interactive(to_unsafe)
    end

    # Enables or disables interactive scene-item handling.
    def interactive=(value : Bool) : Bool
      LibQt6.qt6cr_graphics_view_set_interactive(to_unsafe, value)
      value
    end

    # Returns the current scene rectangle.
    def scene_rect : RectF
      RectF.from_native(LibQt6.qt6cr_graphics_view_scene_rect(to_unsafe))
    end

    # Sets the scene rectangle and returns it.
    def scene_rect=(value : RectF) : RectF
      LibQt6.qt6cr_graphics_view_set_scene_rect(to_unsafe, value.to_native)
      value
    end

    # Returns the content alignment flags.
    def alignment : AlignmentFlag
      AlignmentFlag.from_value(LibQt6.qt6cr_graphics_view_alignment(to_unsafe))
    end

    # Sets the content alignment flags.
    def alignment=(value : AlignmentFlag) : AlignmentFlag
      LibQt6.qt6cr_graphics_view_set_alignment(to_unsafe, value.value)
      value
    end

    # Returns the active painter render hints.
    def render_hints : PainterRenderHint
      PainterRenderHint.from_value(LibQt6.qt6cr_graphics_view_render_hints(to_unsafe))
    end

    # Sets the active painter render hints.
    def render_hints=(value : PainterRenderHint) : PainterRenderHint
      LibQt6.qt6cr_graphics_view_set_render_hints(to_unsafe, value.value)
      value
    end

    # Enables or disables a single painter render hint.
    def set_render_hint(hint : PainterRenderHint, enabled : Bool = true) : Bool
      LibQt6.qt6cr_graphics_view_set_render_hint(to_unsafe, hint.value, enabled)
      enabled
    end

    # Returns the active drag mode.
    def drag_mode : GraphicsViewDragMode
      GraphicsViewDragMode.from_value(LibQt6.qt6cr_graphics_view_drag_mode(to_unsafe))
    end

    # Sets the active drag mode.
    def drag_mode=(value : GraphicsViewDragMode) : GraphicsViewDragMode
      LibQt6.qt6cr_graphics_view_set_drag_mode(to_unsafe, value.value)
      value
    end

    # Returns the cache-mode flags.
    def cache_mode : GraphicsViewCacheModeFlag
      GraphicsViewCacheModeFlag.from_value(LibQt6.qt6cr_graphics_view_cache_mode(to_unsafe))
    end

    # Sets the cache-mode flags.
    def cache_mode=(value : GraphicsViewCacheModeFlag) : GraphicsViewCacheModeFlag
      LibQt6.qt6cr_graphics_view_set_cache_mode(to_unsafe, value.value)
      value
    end

    # Clears cached viewport content and returns `self`.
    def reset_cached_content : self
      LibQt6.qt6cr_graphics_view_reset_cached_content(to_unsafe)
      self
    end

    # Returns the transform anchor used for interactive transforms.
    def transformation_anchor : GraphicsViewViewportAnchor
      GraphicsViewViewportAnchor.from_value(LibQt6.qt6cr_graphics_view_transformation_anchor(to_unsafe))
    end

    # Sets the transform anchor.
    def transformation_anchor=(value : GraphicsViewViewportAnchor) : GraphicsViewViewportAnchor
      LibQt6.qt6cr_graphics_view_set_transformation_anchor(to_unsafe, value.value)
      value
    end

    # Returns the resize anchor.
    def resize_anchor : GraphicsViewViewportAnchor
      GraphicsViewViewportAnchor.from_value(LibQt6.qt6cr_graphics_view_resize_anchor(to_unsafe))
    end

    # Sets the resize anchor.
    def resize_anchor=(value : GraphicsViewViewportAnchor) : GraphicsViewViewportAnchor
      LibQt6.qt6cr_graphics_view_set_resize_anchor(to_unsafe, value.value)
      value
    end

    # Returns the viewport update mode.
    def viewport_update_mode : GraphicsViewViewportUpdateMode
      GraphicsViewViewportUpdateMode.from_value(LibQt6.qt6cr_graphics_view_viewport_update_mode(to_unsafe))
    end

    # Sets the viewport update mode.
    def viewport_update_mode=(value : GraphicsViewViewportUpdateMode) : GraphicsViewViewportUpdateMode
      LibQt6.qt6cr_graphics_view_set_viewport_update_mode(to_unsafe, value.value)
      value
    end

    # Returns the optimization flags.
    def optimization_flags : GraphicsViewOptimizationFlag
      GraphicsViewOptimizationFlag.from_value(LibQt6.qt6cr_graphics_view_optimization_flags(to_unsafe))
    end

    # Sets the optimization flags.
    def optimization_flags=(value : GraphicsViewOptimizationFlag) : GraphicsViewOptimizationFlag
      LibQt6.qt6cr_graphics_view_set_optimization_flags(to_unsafe, value.value)
      value
    end

    # Enables or disables a single optimization flag.
    def set_optimization_flag(flag : GraphicsViewOptimizationFlag, enabled : Bool = true) : Bool
      LibQt6.qt6cr_graphics_view_set_optimization_flag(to_unsafe, flag.value, enabled)
      enabled
    end

    # Returns a copy of the current view transform.
    def transform : QTransform
      QTransform.wrap(LibQt6.qt6cr_graphics_view_transform(to_unsafe), true)
    end

    # Returns a copy of the effective viewport transform.
    def viewport_transform : QTransform
      QTransform.wrap(LibQt6.qt6cr_graphics_view_viewport_transform(to_unsafe), true)
    end

    # Returns `true` when the view transform is not identity.
    def transformed? : Bool
      LibQt6.qt6cr_graphics_view_is_transformed(to_unsafe)
    end

    # Replaces or combines the view transform and returns it.
    def set_transform(value : QTransform, combine : Bool = false) : QTransform
      LibQt6.qt6cr_graphics_view_set_transform(to_unsafe, value.to_unsafe, combine)
      value
    end

    # Resets the view transform and returns `self`.
    def reset_transform : self
      LibQt6.qt6cr_graphics_view_reset_transform(to_unsafe)
      self
    end

    # Rotates the view transform and returns `self`.
    def rotate(angle : Number) : self
      LibQt6.qt6cr_graphics_view_rotate(to_unsafe, angle.to_f64)
      self
    end

    # Scales the view transform and returns `self`.
    def scale(sx : Number, sy : Number) : self
      LibQt6.qt6cr_graphics_view_scale(to_unsafe, sx.to_f64, sy.to_f64)
      self
    end

    # Shears the view transform and returns `self`.
    def shear(sh : Number, sv : Number) : self
      LibQt6.qt6cr_graphics_view_shear(to_unsafe, sh.to_f64, sv.to_f64)
      self
    end

    # Translates the view transform and returns `self`.
    def translate(dx : Number, dy : Number) : self
      LibQt6.qt6cr_graphics_view_translate(to_unsafe, dx.to_f64, dy.to_f64)
      self
    end

    # Centers the viewport on the given scene position and returns `self`.
    def center_on(point : PointF) : self
      LibQt6.qt6cr_graphics_view_center_on(to_unsafe, point.to_native)
      self
    end

    # Ensures the given scene rect is visible and returns `self`.
    def ensure_visible(rect : RectF, x_margin : Int = 50, y_margin : Int = 50) : self
      LibQt6.qt6cr_graphics_view_ensure_visible(to_unsafe, rect.to_native, x_margin, y_margin)
      self
    end

    # Fits the given scene rect into the viewport and returns `self`.
    def fit_in_view(rect : RectF, aspect_ratio_mode : AspectRatioMode = AspectRatioMode::Ignore) : self
      LibQt6.qt6cr_graphics_view_fit_in_view(to_unsafe, rect.to_native, aspect_ratio_mode.value)
      self
    end
  end
end
