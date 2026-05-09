module Qt6
  # Wraps `QGraphicsSceneHelpEvent` for synthetic or live graphics-scene help-event inspection.
  #
  # When obtained from `QEvent#graphics_scene_help_event`, the underlying handle is only
  # valid while the surrounding callback is running.
  class GraphicsSceneHelpEvent < GraphicsSceneEvent
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a graphics-scene help event with an optional event type.
    def initialize(type : EventType = EventType::GraphicsSceneHelp)
      super(LibQt6.qt6cr_graphics_scene_help_event_create(type.value), true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def scene_pos : PointF
      PointF.from_native(LibQt6.qt6cr_graphics_scene_help_event_scene_pos(to_unsafe))
    end

    def scene_pos=(value : PointF) : PointF
      LibQt6.qt6cr_graphics_scene_help_event_set_scene_pos(to_unsafe, value.to_native)
      value
    end

    def screen_pos : Point
      Point.from_native(LibQt6.qt6cr_graphics_scene_help_event_screen_pos(to_unsafe))
    end

    def screen_pos=(value : Point) : Point
      LibQt6.qt6cr_graphics_scene_help_event_set_screen_pos(to_unsafe, value.to_native)
      value
    end
  end
end
