module Qt6
  # Wraps a live `QEvent` during event-filter callbacks.
  #
  # The underlying event handle is only valid while the callback is running.
  class QEvent
    getter to_unsafe : LibQt6::Handle

    def initialize(@to_unsafe : LibQt6::Handle)
    end

    # Returns the raw Qt event type integer.
    def type_value : Int32
      LibQt6.qt6cr_event_type(to_unsafe)
    end

    # Returns the Qt event type when it maps to a known enum value.
    def type : EventType?
      EventType.values.find { |value| value.value == type_value }
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

    # Returns this event reinterpreted as a live `QGestureEvent`.
    def gesture_event : GestureEvent
      GestureEvent.wrap(to_unsafe)
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
  end
end
