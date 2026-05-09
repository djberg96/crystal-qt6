module Qt6
  # Wraps `QGraphicsSceneHoverEvent` for synthetic or live graphics-scene hover inspection.
  #
  # When obtained from `QEvent#graphics_scene_hover_event`, the underlying handle is only
  # valid while the surrounding callback is running.
  class GraphicsSceneHoverEvent < GraphicsSceneEvent
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a graphics-scene hover event with an optional event type.
    def initialize(type : EventType = EventType::GraphicsSceneHoverMove)
      super(LibQt6.qt6cr_graphics_scene_hover_event_create(type.value), true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def pos : PointF
      PointF.from_native(LibQt6.qt6cr_graphics_scene_hover_event_pos(to_unsafe))
    end

    def pos=(value : PointF) : PointF
      LibQt6.qt6cr_graphics_scene_hover_event_set_pos(to_unsafe, value.to_native)
      value
    end

    def scene_pos : PointF
      PointF.from_native(LibQt6.qt6cr_graphics_scene_hover_event_scene_pos(to_unsafe))
    end

    def scene_pos=(value : PointF) : PointF
      LibQt6.qt6cr_graphics_scene_hover_event_set_scene_pos(to_unsafe, value.to_native)
      value
    end

    def screen_pos : Point
      Point.from_native(LibQt6.qt6cr_graphics_scene_hover_event_screen_pos(to_unsafe))
    end

    def screen_pos=(value : Point) : Point
      LibQt6.qt6cr_graphics_scene_hover_event_set_screen_pos(to_unsafe, value.to_native)
      value
    end

    def last_pos : PointF
      PointF.from_native(LibQt6.qt6cr_graphics_scene_hover_event_last_pos(to_unsafe))
    end

    def last_pos=(value : PointF) : PointF
      LibQt6.qt6cr_graphics_scene_hover_event_set_last_pos(to_unsafe, value.to_native)
      value
    end

    def last_scene_pos : PointF
      PointF.from_native(LibQt6.qt6cr_graphics_scene_hover_event_last_scene_pos(to_unsafe))
    end

    def last_scene_pos=(value : PointF) : PointF
      LibQt6.qt6cr_graphics_scene_hover_event_set_last_scene_pos(to_unsafe, value.to_native)
      value
    end

    def last_screen_pos : Point
      Point.from_native(LibQt6.qt6cr_graphics_scene_hover_event_last_screen_pos(to_unsafe))
    end

    def last_screen_pos=(value : Point) : Point
      LibQt6.qt6cr_graphics_scene_hover_event_set_last_screen_pos(to_unsafe, value.to_native)
      value
    end

    def modifiers : Int32
      LibQt6.qt6cr_graphics_scene_hover_event_modifiers(to_unsafe)
    end

    def modifiers=(value : Int) : Int32
      modifiers = value.to_i32
      LibQt6.qt6cr_graphics_scene_hover_event_set_modifiers(to_unsafe, modifiers)
      modifiers
    end
  end
end
