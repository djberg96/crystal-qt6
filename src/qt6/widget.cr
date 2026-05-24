module Qt6
  # Wraps a generic `QWidget`.
  class Widget < QObject
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a widget, optionally parented to another widget.
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_widget_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the current window title.
    def window_title : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_widget_window_title(@to_unsafe))
    end

    # Sets the window title and returns the assigned value.
    def window_title=(value : String) : String
      LibQt6.qt6cr_widget_set_window_title(@to_unsafe, value.to_unsafe)
      value
    end

    # Resizes the widget and returns `self` for chaining.
    def resize(width : Int, height : Int) : self
      LibQt6.qt6cr_widget_resize(@to_unsafe, width, height)
      self
    end

    # Sets the widget geometry and returns `self`.
    def set_geometry(rect : Rect) : self
      LibQt6.qt6cr_widget_set_geometry(@to_unsafe, rect.to_native)
      self
    end

    # Sets the widget geometry from coordinates and returns `self`.
    def set_geometry(x : Int, y : Int, width : Int, height : Int) : self
      set_geometry(Rect.new(x, y, width, height))
    end

    # Shows the widget and returns `self` for chaining.
    def show : self
      LibQt6.qt6cr_widget_show(@to_unsafe)
      self
    end

    # Returns `true` when the widget is a top-level window.
    def window? : Bool
      LibQt6.qt6cr_widget_is_window(@to_unsafe)
    end

    # Shows the widget minimized and returns `self` for chaining.
    def show_minimized : self
      LibQt6.qt6cr_widget_show_minimized(@to_unsafe)
      self
    end

    # Shows the widget fullscreen and returns `self` for chaining.
    def show_full_screen : self
      LibQt6.qt6cr_widget_show_full_screen(@to_unsafe)
      self
    end

    # Restores the widget to its normal state and returns `self` for chaining.
    def show_normal : self
      LibQt6.qt6cr_widget_show_normal(@to_unsafe)
      self
    end

    # Shows the widget maximized and returns `self` for chaining.
    def show_maximized : self
      LibQt6.qt6cr_widget_show_maximized(@to_unsafe)
      self
    end

    # Returns `true` when the widget is currently minimized.
    def minimized? : Bool
      LibQt6.qt6cr_widget_is_minimized(@to_unsafe)
    end

    # Returns `true` when the widget is currently fullscreen.
    def full_screen? : Bool
      LibQt6.qt6cr_widget_is_full_screen(@to_unsafe)
    end

    # Returns `true` when the widget is currently maximized.
    def maximized? : Bool
      LibQt6.qt6cr_widget_is_maximized(@to_unsafe)
    end

    # Returns the widget frame geometry in parent or screen coordinates.
    def frame_geometry : Rect
      Rect.from_native(LibQt6.qt6cr_widget_frame_geometry(@to_unsafe))
    end

    # Returns the widget geometry relative to its parent.
    def geometry : Rect
      Rect.from_native(LibQt6.qt6cr_widget_geometry(@to_unsafe))
    end

    # Returns the geometry used when restoring a maximized or fullscreen widget.
    def normal_geometry : Rect
      Rect.from_native(LibQt6.qt6cr_widget_normal_geometry(@to_unsafe))
    end

    # Returns the widget's parent-relative position.
    def pos : Point
      Point.from_native(LibQt6.qt6cr_widget_pos(@to_unsafe))
    end

    # Returns the widget's x coordinate relative to its parent.
    def x : Int32
      LibQt6.qt6cr_widget_x(@to_unsafe)
    end

    # Returns the widget's y coordinate relative to its parent.
    def y : Int32
      LibQt6.qt6cr_widget_y(@to_unsafe)
    end

    # Returns the widget frame size including window decorations when present.
    def frame_size : Size
      Size.from_native(LibQt6.qt6cr_widget_frame_size(@to_unsafe))
    end

    # Returns the bounding rectangle of visible child widgets.
    def children_rect : Rect
      Rect.from_native(LibQt6.qt6cr_widget_children_rect(@to_unsafe))
    end

    # Returns the combined region occupied by child widgets.
    def children_region : QRegion
      QRegion.wrap(LibQt6.qt6cr_widget_children_region(@to_unsafe), true)
    end

    # Hides the widget and returns `self` for chaining.
    def hide : self
      LibQt6.qt6cr_widget_hide(@to_unsafe)
      self
    end

    # Closes the widget and returns `self` for chaining.
    def close : self
      LibQt6.qt6cr_widget_close(@to_unsafe)
      self
    end

    # Lowers the widget below overlapping siblings and returns `self`.
    def lower : self
      LibQt6.qt6cr_widget_lower(@to_unsafe)
      self
    end

    # Moves the widget underneath the given sibling and returns `self`.
    def stack_under(sibling : Widget) : self
      LibQt6.qt6cr_widget_stack_under(@to_unsafe, sibling.to_unsafe)
      self
    end

    # Returns `true` when Qt considers the widget visible.
    def visible? : Bool
      LibQt6.qt6cr_widget_is_visible(@to_unsafe)
    end

    # Shows or hides the widget.
    def visible=(value : Bool) : Bool
      LibQt6.qt6cr_widget_set_visible(@to_unsafe, value)
      value
    end

    # Returns the widget's current size.
    def size : Size
      Size.from_native(LibQt6.qt6cr_widget_size(@to_unsafe))
    end

    # Returns the widget's local rectangle.
    def rect : RectF
      RectF.from_native(LibQt6.qt6cr_widget_rect(@to_unsafe))
    end

    # Returns the rectangle available after applying contents margins.
    def contents_rect : Rect
      Rect.from_native(LibQt6.qt6cr_widget_contents_rect(@to_unsafe))
    end

    # Returns the current widget contents margins.
    def contents_margins : Margins
      value = LibQt6.qt6cr_widget_contents_margins(@to_unsafe)
      Margins.new(value.left, value.top, value.right, value.bottom)
    end

    # Sets widget contents margins in pixels and returns `self`.
    def set_contents_margins(left : Int, top : Int, right : Int, bottom : Int) : self
      LibQt6.qt6cr_widget_set_contents_margins(@to_unsafe, left.to_i32, top.to_i32, right.to_i32, bottom.to_i32)
      self
    end

    # Returns the installed layout, if any.
    def layout : Layout?
      handle = LibQt6.qt6cr_widget_layout(@to_unsafe)
      handle.null? ? nil : LayoutHandle.wrap(handle)
    end

    # Installs a layout on the widget and returns it.
    def layout=(value : Layout) : Layout
      LibQt6.qt6cr_widget_set_layout(@to_unsafe, value.to_unsafe)
      value.adopt_by_parent!
      value
    end

    # Qt-style alias for `layout=`.
    def set_layout(value : Layout) : self
      self.layout = value
      self
    end

    # Notifies parent layouts that this widget's size hints changed.
    def update_geometry : self
      LibQt6.qt6cr_widget_update_geometry(@to_unsafe)
      self
    end

    # Returns the parent widget, if any.
    def parent_widget : Widget?
      handle = LibQt6.qt6cr_widget_parent_widget(@to_unsafe)
      handle.null? ? nil : Widget.wrap(handle)
    end

    # Reparents the widget and returns it.
    def set_parent(parent : Widget?) : Widget?
      LibQt6.qt6cr_widget_set_parent_widget(@to_unsafe, parent.try(&.to_unsafe) || Pointer(Void).null)
      parent
    end

    # Maps a local point into global screen coordinates.
    def map_to_global(point : Point) : Point
      Point.from_native(LibQt6.qt6cr_widget_map_to_global(@to_unsafe, point.to_native))
    end

    # Maps a global screen point into the widget's local coordinates.
    def map_from_global(point : Point) : Point
      Point.from_native(LibQt6.qt6cr_widget_map_from_global(@to_unsafe, point.to_native))
    end

    # Maps a local point into the parent widget's coordinates.
    def map_to_parent(point : Point) : Point
      Point.from_native(LibQt6.qt6cr_widget_map_to_parent(@to_unsafe, point.to_native))
    end

    # Maps a parent-relative point into the widget's local coordinates.
    def map_from_parent(point : Point) : Point
      Point.from_native(LibQt6.qt6cr_widget_map_from_parent(@to_unsafe, point.to_native))
    end

    # Maps a local point into another widget's coordinates.
    def map_to(widget : Widget, point : Point) : Point
      Point.from_native(LibQt6.qt6cr_widget_map_to(@to_unsafe, widget.to_unsafe, point.to_native))
    end

    # Maps a point from another widget's coordinates into this widget.
    def map_from(widget : Widget, point : Point) : Point
      Point.from_native(LibQt6.qt6cr_widget_map_from(@to_unsafe, widget.to_unsafe, point.to_native))
    end

    # Schedules the widget for repaint and returns `self`.
    def update : self
      LibQt6.qt6cr_widget_update(@to_unsafe)
      self
    end

    # Schedules the given rectangle for repaint and returns `self`.
    def update(rect : Rect) : self
      LibQt6.qt6cr_widget_update_rect(@to_unsafe, rect.to_native)
      self
    end

    # Schedules the given region for repaint and returns `self`.
    def update(region : QRegion) : self
      LibQt6.qt6cr_widget_update_region(@to_unsafe, region.to_unsafe)
      self
    end

    # Returns the widget's current mask region.
    def mask : QRegion
      QRegion.wrap(LibQt6.qt6cr_widget_mask(@to_unsafe), true)
    end

    # Sets or clears the widget mask.
    def mask=(value : QRegion?) : QRegion?
      LibQt6.qt6cr_widget_set_mask(@to_unsafe, value.try(&.to_unsafe) || Pointer(Void).null)
      value
    end

    # Returns the widget palette.
    def palette : QPalette
      QPalette.wrap(LibQt6.qt6cr_widget_palette(@to_unsafe), true)
    end

    # Sets the widget palette.
    def palette=(value : QPalette) : QPalette
      LibQt6.qt6cr_widget_set_palette(@to_unsafe, value.to_unsafe)
      value
    end

    # Returns the widget's graphics effect, if one is installed.
    def graphics_effect : GraphicsEffect?
      handle = LibQt6.qt6cr_widget_graphics_effect(@to_unsafe)
      handle.null? ? nil : GraphicsEffect.wrap(handle)
    end

    # Installs or clears a widget graphics effect.
    def graphics_effect=(value : GraphicsEffect?) : GraphicsEffect?
      LibQt6.qt6cr_widget_set_graphics_effect(@to_unsafe, value.try(&.to_unsafe) || Pointer(Void).null)
      value.try(&.adopt_by_parent!)
      value
    end

    # Captures the widget's current contents into a pixmap.
    def grab : QPixmap
      QPixmap.new(LibQt6.qt6cr_widget_grab(@to_unsafe), true)
    end

    # Returns the widget's style sheet.
    def style_sheet : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_widget_style_sheet(@to_unsafe))
    end

    # Sets the widget's style sheet.
    def style_sheet=(value : String) : String
      LibQt6.qt6cr_widget_set_style_sheet(@to_unsafe, value.to_unsafe)
      value
    end

    # Returns the widget's current style.
    def style : Style?
      handle = LibQt6.qt6cr_widget_style(@to_unsafe)
      handle.null? ? nil : Style.wrap(handle)
    end

    # Sets the widget's current style.
    def style=(value : Style) : Style
      LibQt6.qt6cr_widget_set_style(@to_unsafe, value.to_unsafe)
      value.adopt_by_parent!
      value
    end

    # Returns the widget's tooltip text.
    def tool_tip : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_widget_tool_tip(@to_unsafe))
    end

    # Sets the widget's tooltip text.
    def tool_tip=(value : String) : String
      LibQt6.qt6cr_widget_set_tool_tip(@to_unsafe, value.to_unsafe)
      value
    end

    # Returns the tooltip display duration in milliseconds, or `-1` for the Qt default.
    def tool_tip_duration : Int32
      LibQt6.qt6cr_widget_tool_tip_duration(@to_unsafe)
    end

    # Sets the tooltip display duration in milliseconds.
    def tool_tip_duration=(value : Int) : Int32
      msec = value.to_i32
      LibQt6.qt6cr_widget_set_tool_tip_duration(@to_unsafe, msec)
      msec
    end

    # Returns the widget's status-tip text.
    def status_tip : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_widget_status_tip(@to_unsafe))
    end

    # Sets the widget's status-tip text.
    def status_tip=(value : String) : String
      LibQt6.qt6cr_widget_set_status_tip(@to_unsafe, value.to_unsafe)
      value
    end

    # Returns the widget's What's This help text.
    def whats_this : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_widget_whats_this(@to_unsafe))
    end

    # Sets the widget's What's This help text.
    def whats_this=(value : String) : String
      LibQt6.qt6cr_widget_set_whats_this(@to_unsafe, value.to_unsafe)
      value
    end

    # Returns the widget's accessible name.
    def accessible_name : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_widget_accessible_name(@to_unsafe))
    end

    # Sets the widget's accessible name.
    def accessible_name=(value : String) : String
      LibQt6.qt6cr_widget_set_accessible_name(@to_unsafe, value.to_unsafe)
      value
    end

    # Returns the widget's accessible description.
    def accessible_description : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_widget_accessible_description(@to_unsafe))
    end

    # Sets the widget's accessible description.
    def accessible_description=(value : String) : String
      LibQt6.qt6cr_widget_set_accessible_description(@to_unsafe, value.to_unsafe)
      value
    end

    # Returns the widget's stable accessibility identifier.
    def accessible_identifier : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_widget_accessible_identifier(@to_unsafe))
    end

    # Sets the widget's stable accessibility identifier.
    def accessible_identifier=(value : String) : String
      LibQt6.qt6cr_widget_set_accessible_identifier(@to_unsafe, value.to_unsafe)
      value
    end

    # Returns the widget's current window icon.
    def window_icon : QIcon
      QIcon.wrap(LibQt6.qt6cr_widget_window_icon(@to_unsafe), true)
    end

    # Sets the widget's window icon.
    def window_icon=(value : QIcon) : QIcon
      LibQt6.qt6cr_widget_set_window_icon(@to_unsafe, value.to_unsafe)
      value
    end

    # Returns the window-associated file path.
    def window_file_path : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_widget_window_file_path(@to_unsafe))
    end

    # Sets the window-associated file path.
    def window_file_path=(value : String) : String
      LibQt6.qt6cr_widget_set_window_file_path(@to_unsafe, value.to_unsafe)
      value
    end

    # Returns the current window opacity.
    def window_opacity : Float64
      LibQt6.qt6cr_widget_window_opacity(@to_unsafe)
    end

    # Sets the current window opacity.
    def window_opacity=(value : Number) : Float64
      opacity = value.to_f64
      LibQt6.qt6cr_widget_set_window_opacity(@to_unsafe, opacity)
      opacity
    end

    # Returns `true` when the widget accepts input.
    def enabled? : Bool
      LibQt6.qt6cr_widget_is_enabled(@to_unsafe)
    end

    # Enables or disables the widget.
    def enabled=(value : Bool) : Bool
      LibQt6.qt6cr_widget_set_enabled(@to_unsafe, value)
      value
    end

    # Returns `true` when this widget belongs to the active window.
    def active_window? : Bool
      LibQt6.qt6cr_widget_is_active_window(@to_unsafe)
    end

    # Returns `true` when repaint updates are enabled.
    def updates_enabled? : Bool
      LibQt6.qt6cr_widget_updates_enabled(@to_unsafe)
    end

    # Enables or disables repaint updates.
    def updates_enabled=(value : Bool) : Bool
      LibQt6.qt6cr_widget_set_updates_enabled(@to_unsafe, value)
      value
    end

    # Returns `true` when the mouse cursor is currently over the widget.
    def under_mouse? : Bool
      LibQt6.qt6cr_widget_under_mouse(@to_unsafe)
    end

    # Returns `true` when the widget currently owns keyboard focus.
    def has_focus? : Bool
      LibQt6.qt6cr_widget_has_focus(@to_unsafe)
    end

    # Returns the widget's focus policy.
    def focus_policy : FocusPolicy
      FocusPolicy.from_value(LibQt6.qt6cr_widget_focus_policy(@to_unsafe))
    end

    # Sets the widget's focus policy.
    def focus_policy=(value : FocusPolicy) : FocusPolicy
      LibQt6.qt6cr_widget_set_focus_policy(@to_unsafe, value.value)
      value
    end

    # Gives the widget keyboard focus.
    def set_focus : self
      LibQt6.qt6cr_widget_set_focus(@to_unsafe)
      self
    end

    # Clears keyboard focus from the widget.
    def clear_focus : self
      LibQt6.qt6cr_widget_clear_focus(@to_unsafe)
      self
    end

    # Requests activation for the widget's top-level window.
    def activate_window : self
      LibQt6.qt6cr_widget_activate_window(@to_unsafe)
      self
    end

    # Moves the widget to the given parent-relative position and returns `self`.
    def move(x : Int, y : Int) : self
      LibQt6.qt6cr_widget_move(@to_unsafe, x, y)
      self
    end

    # Recomputes the widget size from its contents and returns `self`.
    def adjust_size : self
      LibQt6.qt6cr_widget_adjust_size(@to_unsafe)
      self
    end

    # Raises the widget above overlapping siblings and returns `self`.
    def raise_to_front : self
      LibQt6.qt6cr_widget_raise_to_front(@to_unsafe)
      self
    end

    # Adds an action to the widget so its shortcuts can be triggered.
    def add_action(action : Action) : Action
      LibQt6.qt6cr_widget_add_action(@to_unsafe, action.to_unsafe)
      action
    end

    # Registers a gesture type for delivery to this widget.
    def grab_gesture(type : GestureType, flags : GestureFlag = GestureFlag::None) : self
      grab_gesture(type.value, flags)
      self
    end

    # Registers a raw gesture type id for delivery to this widget.
    def grab_gesture(type : Int, flags : GestureFlag = GestureFlag::None) : self
      LibQt6.qt6cr_widget_grab_gesture(@to_unsafe, type.to_i32, flags.value)
      self
    end

    # Unregisters a previously grabbed gesture type from this widget.
    def ungrab_gesture(type : GestureType) : self
      ungrab_gesture(type.value)
      self
    end

    # Unregisters a previously grabbed raw gesture type id from this widget.
    def ungrab_gesture(type : Int) : self
      LibQt6.qt6cr_widget_ungrab_gesture(@to_unsafe, type.to_i32)
      self
    end

    # Locks the widget width and returns the assigned value.
    def fixed_width=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_widget_set_fixed_width(@to_unsafe, int_value)
      int_value
    end

    # Locks the widget height and returns the assigned value.
    def fixed_height=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_widget_set_fixed_height(@to_unsafe, int_value)
      int_value
    end

    # Locks the widget to a fixed size and returns `self`.
    def set_fixed_size(width : Int, height : Int) : self
      LibQt6.qt6cr_widget_set_fixed_size(@to_unsafe, width, height)
      self
    end

    # Sends a synthetic wheel event to the widget.
    def simulate_wheel(position : PointF, pixel_delta : PointF = PointF.new(0.0, 0.0), angle_delta : PointF = PointF.new(0.0, 120.0), buttons : Int = 0, modifiers : Int = 0) : self
      LibQt6.qt6cr_widget_simulate_wheel(@to_unsafe, position.to_native, pixel_delta.to_native, angle_delta.to_native, buttons, modifiers)
      self
    end

    # Returns the widget's horizontal size policy.
    def horizontal_size_policy : SizePolicy
      SizePolicy.from_value(LibQt6.qt6cr_widget_horizontal_size_policy(@to_unsafe))
    end

    # Returns the widget's vertical size policy.
    def vertical_size_policy : SizePolicy
      SizePolicy.from_value(LibQt6.qt6cr_widget_vertical_size_policy(@to_unsafe))
    end

    # Sets both size policies and returns `self`.
    def set_size_policy(horizontal : SizePolicy, vertical : SizePolicy) : self
      LibQt6.qt6cr_widget_set_size_policy(@to_unsafe, horizontal.value, vertical.value)
      self
    end

    # Returns the widget's complete size policy value.
    def size_policy : SizePolicyValue
      SizePolicyValue.from_native(LibQt6.qt6cr_widget_size_policy(@to_unsafe))
    end

    # Sets the widget's complete size policy and returns it.
    def size_policy=(value : SizePolicyValue) : SizePolicyValue
      LibQt6.qt6cr_widget_set_size_policy_value(@to_unsafe, value.to_native)
      value
    end

    # Qt-style overload for assigning a full size-policy value.
    def set_size_policy(value : SizePolicyValue) : self
      self.size_policy = value
      self
    end

    # Returns the widget's minimum size.
    def minimum_size : Size
      Size.from_native(LibQt6.qt6cr_widget_minimum_size(@to_unsafe))
    end

    # Sets the widget's minimum size.
    def set_minimum_size(width : Int, height : Int) : self
      LibQt6.qt6cr_widget_set_minimum_size(@to_unsafe, width, height)
      self
    end

    # Returns the widget's minimum width.
    def minimum_width : Int32
      LibQt6.qt6cr_widget_minimum_width(@to_unsafe)
    end

    # Sets the widget's minimum width.
    def minimum_width=(value : Int) : Int32
      LibQt6.qt6cr_widget_set_minimum_width(@to_unsafe, value)
      value.to_i
    end

    # Returns the widget's minimum height.
    def minimum_height : Int32
      LibQt6.qt6cr_widget_minimum_height(@to_unsafe)
    end

    # Sets the widget's minimum height.
    def minimum_height=(value : Int) : Int32
      LibQt6.qt6cr_widget_set_minimum_height(@to_unsafe, value)
      value.to_i
    end

    # Returns the widget's maximum size.
    def maximum_size : Size
      Size.from_native(LibQt6.qt6cr_widget_maximum_size(@to_unsafe))
    end

    # Sets the widget's maximum size.
    def set_maximum_size(width : Int, height : Int) : self
      LibQt6.qt6cr_widget_set_maximum_size(@to_unsafe, width, height)
      self
    end

    # Returns the widget's maximum width.
    def maximum_width : Int32
      LibQt6.qt6cr_widget_maximum_width(@to_unsafe)
    end

    # Sets the widget's maximum width.
    def maximum_width=(value : Int) : Int32
      LibQt6.qt6cr_widget_set_maximum_width(@to_unsafe, value)
      value.to_i
    end

    # Returns the widget's maximum height.
    def maximum_height : Int32
      LibQt6.qt6cr_widget_maximum_height(@to_unsafe)
    end

    # Sets the widget's maximum height.
    def maximum_height=(value : Int) : Int32
      LibQt6.qt6cr_widget_set_maximum_height(@to_unsafe, value)
      value.to_i
    end

    # Returns `true` when the widget accepts drops.
    def accept_drops? : Bool
      LibQt6.qt6cr_widget_accept_drops(@to_unsafe)
    end

    # Enables or disables drop acceptance.
    def accept_drops=(value : Bool) : Bool
      LibQt6.qt6cr_widget_set_accept_drops(@to_unsafe, value)
      value
    end

    # Returns `true` when mouse move events are delivered without a pressed button.
    def mouse_tracking? : Bool
      LibQt6.qt6cr_widget_mouse_tracking(@to_unsafe)
    end

    # Enables or disables mouse tracking.
    def mouse_tracking=(value : Bool) : Bool
      LibQt6.qt6cr_widget_set_mouse_tracking(@to_unsafe, value)
      value
    end

    # Returns the widget's cursor shape.
    def cursor_shape : CursorShape
      CursorShape.from_value(LibQt6.qt6cr_widget_cursor_shape(@to_unsafe))
    end

    # Sets the widget's cursor shape.
    def cursor_shape=(value : CursorShape) : CursorShape
      LibQt6.qt6cr_widget_set_cursor_shape(@to_unsafe, value.value)
      value
    end

    # Returns `true` when mouse events pass through this widget to widgets below.
    def transparent_for_mouse_events? : Bool
      LibQt6.qt6cr_widget_transparent_for_mouse_events(@to_unsafe)
    end

    # Enables or disables transparent-for-mouse-events behavior.
    def transparent_for_mouse_events=(value : Bool) : Bool
      LibQt6.qt6cr_widget_set_transparent_for_mouse_events(@to_unsafe, value)
      value
    end

    # Returns `true` when the Qt widget attribute is enabled.
    def attribute?(attribute : WidgetAttribute) : Bool
      LibQt6.qt6cr_widget_test_attribute(@to_unsafe, attribute.value)
    end

    # Enables or disables a Qt widget attribute and returns `self`.
    def set_attribute(attribute : WidgetAttribute, value : Bool = true) : self
      LibQt6.qt6cr_widget_set_attribute(@to_unsafe, attribute.value, value)
      self
    end

    # Clears a Qt widget attribute and returns `self`.
    def clear_attribute(attribute : WidgetAttribute) : self
      set_attribute(attribute, false)
    end

    # Creates a `VBoxLayout`, yields it for configuration, and returns it.
    def vbox(&block : VBoxLayout ->)
      layout = VBoxLayout.new(self)
      yield layout
      layout
    end

    # Creates an `HBoxLayout`, yields it for configuration, and returns it.
    def hbox(&block : HBoxLayout ->)
      layout = HBoxLayout.new(self)
      yield layout
      layout
    end

    # Creates a `GridLayout`, yields it for configuration, and returns it.
    def grid(&block : GridLayout ->)
      layout = GridLayout.new(self)
      yield layout
      layout
    end

    # Creates a `FormLayout`, yields it for configuration, and returns it.
    def form(&block : FormLayout ->)
      layout = FormLayout.new(self)
      yield layout
      layout
    end

    # Stops tracking this widget as independently owned because a Qt parent now
    # controls its lifetime.
    def adopt_by_parent! : Nil
      @owned = false
    end
  end
end
