module Qt6
  # Wraps `QGraphicsScene` for scene composition, lookup, and rendering.
  class GraphicsScene < QObject
    @scene_rect_changed : Signal(RectF) = Signal(RectF).new
    @selection_changed : Signal() = Signal().new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null
    @callbacks_registered = false

    def scene_rect_changed : Signal(RectF)
      ensure_callbacks_registered
      @scene_rect_changed
    end

    def selection_changed : Signal()
      ensure_callbacks_registered
      @selection_changed
    end

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates an empty graphics scene with an optional QObject parent.
    def initialize(parent : QObject? = nil)
      super(LibQt6.qt6cr_graphics_scene_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    # Creates a graphics scene with an initial scene rectangle.
    def initialize(rect : RectF, parent : QObject? = nil)
      super(LibQt6.qt6cr_graphics_scene_create_with_rect(rect.to_native, parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    # Creates a graphics scene from coordinates with an initial scene rectangle.
    def initialize(x : Number, y : Number, width : Number, height : Number, parent : QObject? = nil)
      initialize(RectF.new(x.to_f64, y.to_f64, width.to_f64, height.to_f64), parent)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    private def ensure_callbacks_registered : Nil
      return if @callbacks_registered

      @scene_rect_changed = Signal(RectF).new
      @selection_changed = Signal().new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_graphics_scene_on_scene_rect_changed(to_unsafe, SCENE_RECT_CHANGED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_graphics_scene_on_selection_changed(to_unsafe, SELECTION_CHANGED_TRAMPOLINE, @callback_userdata)
      @callbacks_registered = true
    end

    # Returns the scene rectangle.
    def scene_rect : RectF
      RectF.from_native(LibQt6.qt6cr_graphics_scene_scene_rect(to_unsafe))
    end

    # Sets the scene rectangle and returns it.
    def scene_rect=(value : RectF) : RectF
      LibQt6.qt6cr_graphics_scene_set_scene_rect(to_unsafe, value.to_native)
      value
    end

    # Qt-style alias for `scene_rect=`.
    def set_scene_rect(value : RectF) : self
      self.scene_rect = value
      self
    end

    # Qt-style overload for assigning the scene rectangle from coordinates.
    def set_scene_rect(x : Number, y : Number, width : Number, height : Number) : self
      self.scene_rect = RectF.new(x.to_f64, y.to_f64, width.to_f64, height.to_f64)
      self
    end

    # Returns the scene's item indexing strategy.
    def item_index_method : GraphicsSceneItemIndexMethod
      GraphicsSceneItemIndexMethod.from_value(LibQt6.qt6cr_graphics_scene_item_index_method(to_unsafe))
    end

    # Sets the scene's item indexing strategy.
    def item_index_method=(value : GraphicsSceneItemIndexMethod) : GraphicsSceneItemIndexMethod
      LibQt6.qt6cr_graphics_scene_set_item_index_method(to_unsafe, value.value)
      value
    end

    # Returns the BSP tree depth.
    def bsp_tree_depth : Int32
      LibQt6.qt6cr_graphics_scene_bsp_tree_depth(to_unsafe)
    end

    # Sets the BSP tree depth and returns it.
    def bsp_tree_depth=(value : Int) : Int32
      depth = value.to_i32
      LibQt6.qt6cr_graphics_scene_set_bsp_tree_depth(to_unsafe, depth)
      depth
    end

    # Returns the union bounding rectangle of all scene items.
    def items_bounding_rect : RectF
      RectF.from_native(LibQt6.qt6cr_graphics_scene_items_bounding_rect(to_unsafe))
    end

    # Returns the scene background brush.
    def background_brush : QBrush
      QBrush.wrap(LibQt6.qt6cr_graphics_scene_background_brush(to_unsafe), true)
    end

    # Sets the scene background brush.
    def background_brush=(value : QBrush) : QBrush
      LibQt6.qt6cr_graphics_scene_set_background_brush(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the scene foreground brush.
    def foreground_brush : QBrush
      QBrush.wrap(LibQt6.qt6cr_graphics_scene_foreground_brush(to_unsafe), true)
    end

    # Sets the scene foreground brush.
    def foreground_brush=(value : QBrush) : QBrush
      LibQt6.qt6cr_graphics_scene_set_foreground_brush(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the scene style, if present.
    def style : Style?
      handle = LibQt6.qt6cr_graphics_scene_style(to_unsafe)
      handle.null? ? nil : Style.wrap(handle)
    end

    # Sets the scene style.
    def style=(value : Style?) : Style?
      LibQt6.qt6cr_graphics_scene_set_style(to_unsafe, value.try(&.to_unsafe) || Pointer(Void).null)
      value
    end

    # Returns the scene font.
    def font : QFont
      QFont.wrap(LibQt6.qt6cr_graphics_scene_font(to_unsafe), true)
    end

    # Sets the scene font.
    def font=(value : QFont) : QFont
      LibQt6.qt6cr_graphics_scene_set_font(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the scene palette.
    def palette : QPalette
      QPalette.wrap(LibQt6.qt6cr_graphics_scene_palette(to_unsafe), true)
    end

    # Sets the scene palette.
    def palette=(value : QPalette) : QPalette
      LibQt6.qt6cr_graphics_scene_set_palette(to_unsafe, value.to_unsafe)
      value
    end

    # Returns `true` when the scene keeps focus sticky across item changes.
    def sticky_focus? : Bool
      LibQt6.qt6cr_graphics_scene_sticky_focus(to_unsafe)
    end

    # Enables or disables sticky focus.
    def sticky_focus=(value : Bool) : Bool
      LibQt6.qt6cr_graphics_scene_set_sticky_focus(to_unsafe, value)
      value
    end

    # Returns the minimum render size threshold.
    def minimum_render_size : Float64
      LibQt6.qt6cr_graphics_scene_minimum_render_size(to_unsafe)
    end

    # Sets the minimum render size threshold and returns it.
    def minimum_render_size=(value : Number) : Float64
      size = value.to_f64
      LibQt6.qt6cr_graphics_scene_set_minimum_render_size(to_unsafe, size)
      size
    end

    # Returns `true` when the scene focuses on touch interaction.
    def focus_on_touch? : Bool
      LibQt6.qt6cr_graphics_scene_focus_on_touch(to_unsafe)
    end

    # Enables or disables touch-driven focus.
    def focus_on_touch=(value : Bool) : Bool
      LibQt6.qt6cr_graphics_scene_set_focus_on_touch(to_unsafe, value)
      value
    end

    # Returns `true` when the scene is active.
    def active? : Bool
      LibQt6.qt6cr_graphics_scene_is_active(to_unsafe)
    end

    # Returns the active panel item, if present.
    def active_panel : GraphicsItem?
      handle = LibQt6.qt6cr_graphics_scene_active_panel(to_unsafe)
      handle.null? ? nil : GraphicsItem.wrap(handle)
    end

    # Sets the active panel item.
    def active_panel=(value : GraphicsItem?) : GraphicsItem?
      LibQt6.qt6cr_graphics_scene_set_active_panel(to_unsafe, value.try(&.graphics_item_handle) || Pointer(Void).null)
      value
    end

    # Returns the active graphics window, if present.
    def active_window : GraphicsWidget?
      handle = LibQt6.qt6cr_graphics_scene_active_window(to_unsafe)
      handle.null? ? nil : GraphicsWidget.wrap(handle)
    end

    # Sets the active graphics window.
    def active_window=(value : GraphicsWidget?) : GraphicsWidget?
      LibQt6.qt6cr_graphics_scene_set_active_window(to_unsafe, value.try(&.to_unsafe) || Pointer(Void).null)
      value
    end

    # Returns the focused item, if present.
    def focus_item : GraphicsItem?
      handle = LibQt6.qt6cr_graphics_scene_focus_item(to_unsafe)
      handle.null? ? nil : GraphicsItem.wrap(handle)
    end

    # Sets the focused item and returns it.
    def focus_item=(value : GraphicsItem?) : GraphicsItem?
      set_focus_item(value)
    end

    # Sets the focused item with an optional focus reason and returns it.
    def set_focus_item(value : GraphicsItem?, reason : FocusReason = FocusReason::OtherFocusReason) : GraphicsItem?
      LibQt6.qt6cr_graphics_scene_set_focus_item(to_unsafe, value.try(&.graphics_item_handle) || Pointer(Void).null, reason.value)
      value
    end

    # Returns `true` when the scene currently has focus.
    def has_focus? : Bool
      LibQt6.qt6cr_graphics_scene_has_focus(to_unsafe)
    end

    # Focuses the scene and returns `self`.
    def set_focus(reason : FocusReason = FocusReason::OtherFocusReason) : self
      LibQt6.qt6cr_graphics_scene_set_focus(to_unsafe, reason.value)
      self
    end

    # Clears scene focus and returns `self`.
    def clear_focus : self
      LibQt6.qt6cr_graphics_scene_clear_focus(to_unsafe)
      self
    end

    # Returns the current mouse grabber item, if present.
    def mouse_grabber_item : GraphicsItem?
      handle = LibQt6.qt6cr_graphics_scene_mouse_grabber_item(to_unsafe)
      handle.null? ? nil : GraphicsItem.wrap(handle)
    end

    # Returns the views attached to this scene.
    def views : Array(GraphicsView)
      Qt6.copy_and_release_handles(LibQt6.qt6cr_graphics_scene_views(to_unsafe)).map do |handle|
        GraphicsView.wrap(handle).as(GraphicsView)
      end
    end

    # Renders the scene into the given painter.
    def render(painter : QPainter, target : RectF = RectF.new(0.0, 0.0, 0.0, 0.0), source : RectF = RectF.new(0.0, 0.0, 0.0, 0.0), aspect_ratio_mode : AspectRatioMode = AspectRatioMode::Keep) : self
      LibQt6.qt6cr_graphics_scene_render(to_unsafe, painter.to_unsafe, target.to_native, source.to_native, aspect_ratio_mode.value)
      self
    end

    # Schedules an update for the whole scene and returns `self`.
    def update : self
      LibQt6.qt6cr_graphics_scene_update(to_unsafe, RectF.new(0.0, 0.0, 0.0, 0.0).to_native)
      self
    end

    # Schedules an update for the given scene rectangle and returns `self`.
    def update(rect : RectF) : self
      LibQt6.qt6cr_graphics_scene_update(to_unsafe, rect.to_native)
      self
    end

    # Invalidates the given scene rectangle and returns `self`.
    def invalidate(rect : RectF = RectF.new(0.0, 0.0, 0.0, 0.0), layers : GraphicsSceneLayer = GraphicsSceneLayer::AllLayers) : self
      LibQt6.qt6cr_graphics_scene_invalidate(to_unsafe, rect.to_native, layers.value)
      self
    end

    # Advances all items in the scene and returns `self`.
    def advance : self
      LibQt6.qt6cr_graphics_scene_advance(to_unsafe)
      self
    end

    # Clears the current item selection and returns `self`.
    def clear_selection : self
      LibQt6.qt6cr_graphics_scene_clear_selection(to_unsafe)
      self
    end

    # Returns all scene items in the requested sort order.
    def items(order : SortOrder = SortOrder::Descending) : Array(GraphicsItem)
      Qt6.copy_and_release_handles(LibQt6.qt6cr_graphics_scene_items(to_unsafe, order.value)).map do |handle|
        GraphicsItem.wrap(handle).as(GraphicsItem)
      end
    end

    # Returns scene items at the given position.
    def items(point : PointF, mode : GraphicsItemSelectionMode = GraphicsItemSelectionMode::IntersectsItemShape, order : SortOrder = SortOrder::Descending, device_transform : QTransform? = nil) : Array(GraphicsItem)
      Qt6.copy_and_release_handles(
        LibQt6.qt6cr_graphics_scene_items_at_point(to_unsafe, point.to_native, mode.value, order.value, device_transform.try(&.to_unsafe) || Pointer(Void).null)
      ).map do |handle|
        GraphicsItem.wrap(handle).as(GraphicsItem)
      end
    end

    # Returns scene items intersecting the given rectangle.
    def items(rect : RectF, mode : GraphicsItemSelectionMode = GraphicsItemSelectionMode::IntersectsItemShape, order : SortOrder = SortOrder::Descending, device_transform : QTransform? = nil) : Array(GraphicsItem)
      Qt6.copy_and_release_handles(
        LibQt6.qt6cr_graphics_scene_items_in_rect(to_unsafe, rect.to_native, mode.value, order.value, device_transform.try(&.to_unsafe) || Pointer(Void).null)
      ).map do |handle|
        GraphicsItem.wrap(handle).as(GraphicsItem)
      end
    end

    # Returns scene items intersecting the given painter path.
    def items(path : QPainterPath, mode : GraphicsItemSelectionMode = GraphicsItemSelectionMode::IntersectsItemShape, order : SortOrder = SortOrder::Descending, device_transform : QTransform? = nil) : Array(GraphicsItem)
      Qt6.copy_and_release_handles(
        LibQt6.qt6cr_graphics_scene_items_in_path(to_unsafe, path.to_unsafe, mode.value, order.value, device_transform.try(&.to_unsafe) || Pointer(Void).null)
      ).map do |handle|
        GraphicsItem.wrap(handle).as(GraphicsItem)
      end
    end

    # Returns items colliding with the given scene item.
    def colliding_items(item : GraphicsItem, mode : GraphicsItemSelectionMode = GraphicsItemSelectionMode::IntersectsItemShape) : Array(GraphicsItem)
      Qt6.copy_and_release_handles(LibQt6.qt6cr_graphics_scene_colliding_items(to_unsafe, item.graphics_item_handle, mode.value)).map do |handle|
        GraphicsItem.wrap(handle).as(GraphicsItem)
      end
    end

    # Returns the topmost item at the given scene position, if any.
    def item_at(point : PointF, device_transform : QTransform? = nil) : GraphicsItem?
      handle = LibQt6.qt6cr_graphics_scene_item_at(to_unsafe, point.to_native, device_transform.try(&.to_unsafe) || Pointer(Void).null)
      handle.null? ? nil : GraphicsItem.wrap(handle)
    end

    # Returns the currently selected scene items.
    def selected_items : Array(GraphicsItem)
      Qt6.copy_and_release_handles(LibQt6.qt6cr_graphics_scene_selected_items(to_unsafe)).map do |handle|
        GraphicsItem.wrap(handle).as(GraphicsItem)
      end
    end

    # Adds an existing item to the scene and transfers ownership to Qt.
    def add_item(item : GraphicsItem) : GraphicsItem
      LibQt6.qt6cr_graphics_scene_add_item(to_unsafe, item.graphics_item_handle)
      item.adopt_by_owner!
      item
    end

    # Removes an item from the scene and hands ownership back to Crystal when possible.
    def remove_item(item : GraphicsItem) : GraphicsItem
      LibQt6.qt6cr_graphics_scene_remove_item(to_unsafe, item.graphics_item_handle)
      item.assume_ownership! if item.parent_item.nil? && item.group.nil?
      item
    end

    # Adds an ellipse item owned by the scene.
    def add_ellipse(rect : RectF, pen : QPen? = nil, brush : QBrush? = nil) : GraphicsEllipseItem
      GraphicsEllipseItem.wrap(LibQt6.qt6cr_graphics_scene_add_ellipse(to_unsafe, rect.to_native, pen.try(&.to_unsafe) || Pointer(Void).null, brush.try(&.to_unsafe) || Pointer(Void).null))
    end

    # Adds an ellipse item from coordinates owned by the scene.
    def add_ellipse(x : Number, y : Number, width : Number, height : Number, pen : QPen? = nil, brush : QBrush? = nil) : GraphicsEllipseItem
      add_ellipse(RectF.new(x.to_f64, y.to_f64, width.to_f64, height.to_f64), pen, brush)
    end

    # Adds a line item owned by the scene.
    def add_line(line : LineF, pen : QPen? = nil) : GraphicsLineItem
      GraphicsLineItem.wrap(LibQt6.qt6cr_graphics_scene_add_line(to_unsafe, line.to_native, pen.try(&.to_unsafe) || Pointer(Void).null))
    end

    # Adds a line item from coordinates owned by the scene.
    def add_line(x1 : Number, y1 : Number, x2 : Number, y2 : Number, pen : QPen? = nil) : GraphicsLineItem
      add_line(LineF.new(x1.to_f64, y1.to_f64, x2.to_f64, y2.to_f64), pen)
    end

    # Adds a path item owned by the scene.
    def add_path(path : QPainterPath, pen : QPen? = nil, brush : QBrush? = nil) : GraphicsPathItem
      GraphicsPathItem.wrap(LibQt6.qt6cr_graphics_scene_add_path(to_unsafe, path.to_unsafe, pen.try(&.to_unsafe) || Pointer(Void).null, brush.try(&.to_unsafe) || Pointer(Void).null))
    end

    # Adds a pixmap item owned by the scene.
    def add_pixmap(pixmap : QPixmap) : GraphicsPixmapItem
      GraphicsPixmapItem.wrap(LibQt6.qt6cr_graphics_scene_add_pixmap(to_unsafe, pixmap.to_unsafe))
    end

    # Adds a polygon item owned by the scene.
    def add_polygon(polygon : QPolygonF, pen : QPen? = nil, brush : QBrush? = nil) : GraphicsPolygonItem
      GraphicsPolygonItem.wrap(LibQt6.qt6cr_graphics_scene_add_polygon(to_unsafe, polygon.to_unsafe, pen.try(&.to_unsafe) || Pointer(Void).null, brush.try(&.to_unsafe) || Pointer(Void).null))
    end

    # Adds a rectangle item owned by the scene.
    def add_rect(rect : RectF, pen : QPen? = nil, brush : QBrush? = nil) : GraphicsRectItem
      GraphicsRectItem.wrap(LibQt6.qt6cr_graphics_scene_add_rect(to_unsafe, rect.to_native, pen.try(&.to_unsafe) || Pointer(Void).null, brush.try(&.to_unsafe) || Pointer(Void).null))
    end

    # Adds a rectangle item from coordinates owned by the scene.
    def add_rect(x : Number, y : Number, width : Number, height : Number, pen : QPen? = nil, brush : QBrush? = nil) : GraphicsRectItem
      add_rect(RectF.new(x.to_f64, y.to_f64, width.to_f64, height.to_f64), pen, brush)
    end

    # Registers a block for scene-rect changes.
    def on_scene_rect_changed(&block : RectF ->) : self
      ensure_callbacks_registered
      @scene_rect_changed.connect { |rect| block.call(rect) }
      self
    end

    # Registers a block for selection changes.
    def on_selection_changed(&block : ->) : self
      ensure_callbacks_registered
      @selection_changed.connect { block.call }
      self
    end

    protected def emit_scene_rect_changed : Nil
      @scene_rect_changed.emit(scene_rect)
    end

    protected def emit_selection_changed : Nil
      @selection_changed.emit
    end

    private SCENE_RECT_CHANGED_TRAMPOLINE = ->(userdata : Void*) do
      Box(GraphicsScene).unbox(userdata).emit_scene_rect_changed
    end

    private SELECTION_CHANGED_TRAMPOLINE = ->(userdata : Void*) do
      Box(GraphicsScene).unbox(userdata).emit_selection_changed
    end
  end
end
