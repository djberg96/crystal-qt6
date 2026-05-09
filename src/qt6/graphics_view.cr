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

    # Creates a graphics view with an attached scene and optional parent.
    def initialize(scene : GraphicsScene, parent : Widget? = nil)
      super(LibQt6.qt6cr_graphics_view_create_with_scene(scene.to_unsafe, parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns Qt's preferred size for the view.
    def size_hint : Size
      Size.from_native(LibQt6.qt6cr_graphics_view_size_hint(to_unsafe))
    end

    # Returns the attached graphics scene, if present.
    def scene : GraphicsScene?
      handle = LibQt6.qt6cr_graphics_view_scene(to_unsafe)
      handle.null? ? nil : GraphicsScene.wrap(handle)
    end

    # Attaches a graphics scene to the view.
    def scene=(value : GraphicsScene?) : GraphicsScene?
      LibQt6.qt6cr_graphics_view_set_scene(to_unsafe, value.try(&.to_unsafe) || Pointer(Void).null)
      value
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

    # Returns the selection mode used by rubber-band drags.
    def rubber_band_selection_mode : GraphicsItemSelectionMode
      GraphicsItemSelectionMode.from_value(LibQt6.qt6cr_graphics_view_rubber_band_selection_mode(to_unsafe))
    end

    # Sets the selection mode used by rubber-band drags.
    def rubber_band_selection_mode=(value : GraphicsItemSelectionMode) : GraphicsItemSelectionMode
      LibQt6.qt6cr_graphics_view_set_rubber_band_selection_mode(to_unsafe, value.value)
      value
    end

    # Returns the current viewport rubber-band rect.
    def rubber_band_rect : Rect
      Rect.from_native(LibQt6.qt6cr_graphics_view_rubber_band_rect(to_unsafe))
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

    # Centers the viewport on the given scene position.
    def center_on(x : Number, y : Number) : self
      center_on(PointF.new(x.to_f64, y.to_f64))
    end

    # Centers the viewport on the given scene item.
    def center_on(item : GraphicsItem) : self
      LibQt6.qt6cr_graphics_view_center_on_item(to_unsafe, item.graphics_item_handle)
      self
    end

    # Ensures the given scene rect is visible and returns `self`.
    def ensure_visible(rect : RectF, x_margin : Int = 50, y_margin : Int = 50) : self
      LibQt6.qt6cr_graphics_view_ensure_visible(to_unsafe, rect.to_native, x_margin, y_margin)
      self
    end

    # Ensures the given scene rect is visible and returns `self`.
    def ensure_visible(x : Number, y : Number, width : Number, height : Number, x_margin : Int = 50, y_margin : Int = 50) : self
      ensure_visible(RectF.new(x.to_f64, y.to_f64, width.to_f64, height.to_f64), x_margin, y_margin)
    end

    # Ensures the given scene item is visible and returns `self`.
    def ensure_visible(item : GraphicsItem, x_margin : Int = 50, y_margin : Int = 50) : self
      LibQt6.qt6cr_graphics_view_ensure_visible_item(to_unsafe, item.graphics_item_handle, x_margin, y_margin)
      self
    end

    # Fits the given scene rect into the viewport and returns `self`.
    def fit_in_view(rect : RectF, aspect_ratio_mode : AspectRatioMode = AspectRatioMode::Ignore) : self
      LibQt6.qt6cr_graphics_view_fit_in_view(to_unsafe, rect.to_native, aspect_ratio_mode.value)
      self
    end

    # Fits the given scene rect into the viewport and returns `self`.
    def fit_in_view(x : Number, y : Number, width : Number, height : Number, aspect_ratio_mode : AspectRatioMode = AspectRatioMode::Ignore) : self
      fit_in_view(RectF.new(x.to_f64, y.to_f64, width.to_f64, height.to_f64), aspect_ratio_mode)
    end

    # Fits the given scene item into the viewport and returns `self`.
    def fit_in_view(item : GraphicsItem, aspect_ratio_mode : AspectRatioMode = AspectRatioMode::Ignore) : self
      LibQt6.qt6cr_graphics_view_fit_in_view_item(to_unsafe, item.graphics_item_handle, aspect_ratio_mode.value)
      self
    end

    # Renders the view into the target painter.
    def render(painter : QPainter, target : RectF = RectF.new(0.0, 0.0, 0.0, 0.0), source : Rect = Rect.new(0, 0, 0, 0), aspect_ratio_mode : AspectRatioMode = AspectRatioMode::Keep) : self
      LibQt6.qt6cr_graphics_view_render(to_unsafe, painter.to_unsafe, target.to_native, source.to_native, aspect_ratio_mode.value)
      self
    end

    # Returns visible items ordered by Qt's default view stacking rules.
    def items : Array(GraphicsItem)
      Qt6.copy_and_release_handles(LibQt6.qt6cr_graphics_view_items(to_unsafe)).map do |handle|
        GraphicsItem.wrap(handle)
      end
    end

    # Returns items at the given viewport point.
    def items(point : Point) : Array(GraphicsItem)
      Qt6.copy_and_release_handles(LibQt6.qt6cr_graphics_view_items_at(to_unsafe, point.to_native)).map do |handle|
        GraphicsItem.wrap(handle)
      end
    end

    # Returns items intersecting the given viewport rect.
    def items(rect : Rect, mode : GraphicsItemSelectionMode = GraphicsItemSelectionMode::IntersectsItemShape) : Array(GraphicsItem)
      Qt6.copy_and_release_handles(LibQt6.qt6cr_graphics_view_items_in_rect(to_unsafe, rect.to_native, mode.value)).map do |handle|
        GraphicsItem.wrap(handle)
      end
    end

    # Returns items intersecting the given viewport polygon.
    def items(polygon : QPolygon, mode : GraphicsItemSelectionMode = GraphicsItemSelectionMode::IntersectsItemShape) : Array(GraphicsItem)
      Qt6.copy_and_release_handles(LibQt6.qt6cr_graphics_view_items_in_polygon(to_unsafe, polygon.to_unsafe, mode.value)).map do |handle|
        GraphicsItem.wrap(handle)
      end
    end

    # Returns items intersecting the given viewport path.
    def items(path : QPainterPath, mode : GraphicsItemSelectionMode = GraphicsItemSelectionMode::IntersectsItemShape) : Array(GraphicsItem)
      Qt6.copy_and_release_handles(LibQt6.qt6cr_graphics_view_items_in_path(to_unsafe, path.to_unsafe, mode.value)).map do |handle|
        GraphicsItem.wrap(handle)
      end
    end

    # Returns the topmost item at the given viewport point, if any.
    def item_at(point : Point) : GraphicsItem?
      handle = LibQt6.qt6cr_graphics_view_item_at(to_unsafe, point.to_native)
      handle.null? ? nil : GraphicsItem.wrap(handle)
    end

    # Returns the topmost item at the given viewport coordinates, if any.
    def item_at(x : Number, y : Number) : GraphicsItem?
      item_at(Point.new(x.to_i, y.to_i))
    end

    # Maps a viewport point into scene coordinates.
    def map_to_scene(point : Point) : PointF
      PointF.from_native(LibQt6.qt6cr_graphics_view_map_to_scene_point(to_unsafe, point.to_native))
    end

    # Maps viewport coordinates into scene coordinates.
    def map_to_scene(x : Number, y : Number) : PointF
      map_to_scene(Point.new(x.to_i, y.to_i))
    end

    # Maps a viewport rect into scene coordinates.
    def map_to_scene(rect : Rect) : QPolygonF
      QPolygonF.wrap(LibQt6.qt6cr_graphics_view_map_to_scene_rect(to_unsafe, rect.to_native), true)
    end

    # Maps viewport coordinates into a scene polygon.
    def map_to_scene(x : Number, y : Number, width : Number, height : Number) : QPolygonF
      map_to_scene(Rect.new(x.to_i, y.to_i, width.to_i, height.to_i))
    end

    # Maps a viewport polygon into scene coordinates.
    def map_to_scene(polygon : QPolygon) : QPolygonF
      QPolygonF.wrap(LibQt6.qt6cr_graphics_view_map_to_scene_polygon(to_unsafe, polygon.to_unsafe), true)
    end

    # Maps a viewport path into scene coordinates.
    def map_to_scene(path : QPainterPath) : QPainterPath
      QPainterPath.wrap(LibQt6.qt6cr_graphics_view_map_to_scene_path(to_unsafe, path.to_unsafe), true)
    end

    # Maps a scene point into viewport coordinates.
    def map_from_scene(point : PointF) : Point
      Point.from_native(LibQt6.qt6cr_graphics_view_map_from_scene_point(to_unsafe, point.to_native))
    end

    # Maps scene coordinates into viewport coordinates.
    def map_from_scene(x : Number, y : Number) : Point
      map_from_scene(PointF.new(x.to_f64, y.to_f64))
    end

    # Maps a scene rect into viewport coordinates.
    def map_from_scene(rect : RectF) : QPolygon
      QPolygon.wrap(LibQt6.qt6cr_graphics_view_map_from_scene_rect(to_unsafe, rect.to_native), true)
    end

    # Maps scene coordinates into a viewport polygon.
    def map_from_scene(x : Number, y : Number, width : Number, height : Number) : QPolygon
      map_from_scene(RectF.new(x.to_f64, y.to_f64, width.to_f64, height.to_f64))
    end

    # Maps a scene polygon into viewport coordinates.
    def map_from_scene(polygon : QPolygonF) : QPolygon
      QPolygon.wrap(LibQt6.qt6cr_graphics_view_map_from_scene_polygon(to_unsafe, polygon.to_unsafe), true)
    end

    # Maps a scene path into viewport coordinates.
    def map_from_scene(path : QPainterPath) : QPainterPath
      QPainterPath.wrap(LibQt6.qt6cr_graphics_view_map_from_scene_path(to_unsafe, path.to_unsafe), true)
    end

    # Invalidates cached scene layers within the given rect.
    def invalidate_scene(rect : RectF = RectF.new(0.0, 0.0, 0.0, 0.0), layers : GraphicsSceneLayer = GraphicsSceneLayer::AllLayers) : self
      LibQt6.qt6cr_graphics_view_invalidate_scene(to_unsafe, rect.to_native, layers.value)
      self
    end

    # Updates the internal scene rect cache used by the view.
    def update_scene_rect(rect : RectF) : self
      LibQt6.qt6cr_graphics_view_update_scene_rect(to_unsafe, rect.to_native)
      self
    end
  end
end
