module Qt6
  # Wraps a `QEvent`.
  #
  # Events received from callbacks are borrowed and only valid while Qt is
  # delivering them. Events constructed in Crystal, or returned from `#clone`,
  # are owned and released with other native resources.
  class QEvent < NativeResource
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def self.register_event_type(hint : Int = -1) : Int32
      LibQt6.qt6cr_event_register_event_type(hint.to_i32)
    end

    # Wraps a borrowed live event handle.
    def initialize(handle : LibQt6::Handle)
      super(handle, false)
    end

    # Creates a generic event with the given type.
    def initialize(type : EventType)
      super(LibQt6.qt6cr_event_create(type.value))
    end

    def initialize(type : Int)
      super(LibQt6.qt6cr_event_create(type.to_i32))
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def clone : QEvent
      QEvent.wrap(LibQt6.qt6cr_event_clone(to_unsafe), true)
    end

    # Returns the raw Qt event type integer.
    def type_value : Int32
      LibQt6.qt6cr_event_type(to_unsafe)
    end

    # Returns the Qt event type when it maps to a known enum value.
    def type : EventType?
      EventType.values.find { |value| value.value == type_value }
    end

    def spontaneous? : Bool
      LibQt6.qt6cr_event_spontaneous(to_unsafe)
    end

    def input_event? : Bool
      LibQt6.qt6cr_event_is_input_event(to_unsafe)
    end

    def pointer_event? : Bool
      LibQt6.qt6cr_event_is_pointer_event(to_unsafe)
    end

    def single_point_event? : Bool
      LibQt6.qt6cr_event_is_single_point_event(to_unsafe)
    end

    # Marks the event as accepted.
    def accept : self
      LibQt6.qt6cr_event_accept(to_unsafe)
      self
    end

    # Marks the event as ignored.
    def ignore : self
      LibQt6.qt6cr_event_ignore(to_unsafe)
      self
    end

    # Returns whether the event is currently accepted.
    def accepted? : Bool
      LibQt6.qt6cr_event_is_accepted(to_unsafe)
    end

    # Returns mouse-event details when this event is a mouse event.
    def mouse_event : MouseEvent
      MouseEvent.from_native(LibQt6.qt6cr_event_mouse_event(to_unsafe))
    end

    # Returns wheel-event details when this event is a wheel event.
    def wheel_event : WheelEvent
      WheelEvent.from_native(LibQt6.qt6cr_event_wheel_event(to_unsafe))
    end

    # Returns this event reinterpreted as a live `QGestureEvent`.
    def gesture_event : GestureEvent
      GestureEvent.wrap(to_unsafe)
    end

    def action_event : ActionEvent
      ActionEvent.wrap(to_unsafe)
    end

    def child_event : ChildEvent
      ChildEvent.wrap(to_unsafe)
    end

    def child_window_event : ChildWindowEvent
      ChildWindowEvent.wrap(to_unsafe)
    end

    def close_event : CloseEvent
      CloseEvent.wrap(to_unsafe)
    end

    def drag_leave_event : DragLeaveEvent
      DragLeaveEvent.wrap(to_unsafe)
    end

    def drop_event : DropEvent
      DropEvent.wrap(to_unsafe)
    end

    def dynamic_property_change_event : DynamicPropertyChangeEvent
      DynamicPropertyChangeEvent.wrap(to_unsafe)
    end

    def expose_event : ExposeEvent
      ExposeEvent.wrap(to_unsafe)
    end

    def file_open_event : FileOpenEvent
      FileOpenEvent.wrap(to_unsafe)
    end

    def focus_event : FocusEvent
      FocusEvent.wrap(to_unsafe)
    end

    def help_event : HelpEvent
      HelpEvent.wrap(to_unsafe)
    end

    def hide_event : HideEvent
      HideEvent.wrap(to_unsafe)
    end

    def icon_drag_event : IconDragEvent
      IconDragEvent.wrap(to_unsafe)
    end

    def input_event : InputEvent
      InputEvent.wrap(to_unsafe)
    end

    def input_method_event : InputMethodEvent
      InputMethodEvent.wrap(to_unsafe)
    end

    def input_method_query_event : InputMethodQueryEvent
      InputMethodQueryEvent.wrap(to_unsafe)
    end

    def move_event : MoveEvent
      MoveEvent.wrap(to_unsafe)
    end

    def paint_event : PaintEvent
      PaintEvent.wrap(to_unsafe)
    end

    def platform_surface_event : PlatformSurfaceEvent
      PlatformSurfaceEvent.wrap(to_unsafe)
    end

    def resize_event : ResizeEvent
      ResizeEvent.wrap(to_unsafe)
    end

    def scroll_event : ScrollEvent
      ScrollEvent.wrap(to_unsafe)
    end

    def scroll_prepare_event : ScrollPrepareEvent
      ScrollPrepareEvent.wrap(to_unsafe)
    end

    def shortcut_event : ShortcutEvent
      ShortcutEvent.wrap(to_unsafe)
    end

    def show_event : ShowEvent
      ShowEvent.wrap(to_unsafe)
    end

    def status_tip_event : StatusTipEvent
      StatusTipEvent.wrap(to_unsafe)
    end

    def timer_event : TimerEvent
      TimerEvent.wrap(to_unsafe)
    end

    def whats_this_clicked_event : WhatsThisClickedEvent
      WhatsThisClickedEvent.wrap(to_unsafe)
    end

    def window_state_change_event : WindowStateChangeEvent
      WindowStateChangeEvent.wrap(to_unsafe)
    end

    # Returns this event reinterpreted as a live `QGraphicsSceneEvent`.
    def graphics_scene_event : GraphicsSceneEvent
      GraphicsSceneEvent.wrap(to_unsafe)
    end

    # Returns this event reinterpreted as a live `QGraphicsSceneContextMenuEvent`.
    def graphics_scene_context_menu_event : GraphicsSceneContextMenuEvent
      GraphicsSceneContextMenuEvent.wrap(to_unsafe)
    end

    # Returns this event reinterpreted as a live `QGraphicsSceneDragDropEvent`.
    def graphics_scene_drag_drop_event : GraphicsSceneDragDropEvent
      GraphicsSceneDragDropEvent.wrap(to_unsafe)
    end

    # Returns this event reinterpreted as a live `QGraphicsSceneHelpEvent`.
    def graphics_scene_help_event : GraphicsSceneHelpEvent
      GraphicsSceneHelpEvent.wrap(to_unsafe)
    end

    # Returns this event reinterpreted as a live `QGraphicsSceneHoverEvent`.
    def graphics_scene_hover_event : GraphicsSceneHoverEvent
      GraphicsSceneHoverEvent.wrap(to_unsafe)
    end

    # Returns this event reinterpreted as a live `QGraphicsSceneMouseEvent`.
    def graphics_scene_mouse_event : GraphicsSceneMouseEvent
      GraphicsSceneMouseEvent.wrap(to_unsafe)
    end

    # Returns this event reinterpreted as a live `QGraphicsSceneMoveEvent`.
    def graphics_scene_move_event : GraphicsSceneMoveEvent
      GraphicsSceneMoveEvent.wrap(to_unsafe)
    end

    # Returns this event reinterpreted as a live `QGraphicsSceneWheelEvent`.
    def graphics_scene_wheel_event : GraphicsSceneWheelEvent
      GraphicsSceneWheelEvent.wrap(to_unsafe)
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_event_destroy(to_unsafe)
    end
  end
end
