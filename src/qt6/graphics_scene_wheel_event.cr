module Qt6
  # Wraps `QGraphicsSceneWheelEvent` for synthetic or live graphics-scene wheel inspection.
  #
  # When obtained from `QEvent#graphics_scene_wheel_event`, the underlying handle is only
  # valid while the surrounding callback is running.
  class GraphicsSceneWheelEvent < GraphicsSceneEvent
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a graphics-scene wheel event with an optional event type.
    def initialize(type : EventType = EventType::GraphicsSceneWheel)
      super(LibQt6.qt6cr_graphics_scene_wheel_event_create(type.value), true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def pos : PointF
      PointF.from_native(LibQt6.qt6cr_graphics_scene_wheel_event_pos(to_unsafe))
    end

    def pos=(value : PointF) : PointF
      LibQt6.qt6cr_graphics_scene_wheel_event_set_pos(to_unsafe, value.to_native)
      value
    end

    def scene_pos : PointF
      PointF.from_native(LibQt6.qt6cr_graphics_scene_wheel_event_scene_pos(to_unsafe))
    end

    def scene_pos=(value : PointF) : PointF
      LibQt6.qt6cr_graphics_scene_wheel_event_set_scene_pos(to_unsafe, value.to_native)
      value
    end

    def screen_pos : Point
      Point.from_native(LibQt6.qt6cr_graphics_scene_wheel_event_screen_pos(to_unsafe))
    end

    def screen_pos=(value : Point) : Point
      LibQt6.qt6cr_graphics_scene_wheel_event_set_screen_pos(to_unsafe, value.to_native)
      value
    end

    def buttons : Int32
      LibQt6.qt6cr_graphics_scene_wheel_event_buttons(to_unsafe)
    end

    def buttons=(value : Int) : Int32
      buttons = value.to_i32
      LibQt6.qt6cr_graphics_scene_wheel_event_set_buttons(to_unsafe, buttons)
      buttons
    end

    def modifiers : Int32
      LibQt6.qt6cr_graphics_scene_wheel_event_modifiers(to_unsafe)
    end

    def modifiers=(value : Int) : Int32
      modifiers = value.to_i32
      LibQt6.qt6cr_graphics_scene_wheel_event_set_modifiers(to_unsafe, modifiers)
      modifiers
    end

    def delta : Int32
      LibQt6.qt6cr_graphics_scene_wheel_event_delta(to_unsafe)
    end

    def delta=(value : Int) : Int32
      delta = value.to_i32
      LibQt6.qt6cr_graphics_scene_wheel_event_set_delta(to_unsafe, delta)
      delta
    end

    def orientation : Orientation
      Orientation.from_value(LibQt6.qt6cr_graphics_scene_wheel_event_orientation(to_unsafe))
    end

    def orientation=(value : Orientation) : Orientation
      LibQt6.qt6cr_graphics_scene_wheel_event_set_orientation(to_unsafe, value.value)
      value
    end

    def phase : ScrollPhase
      ScrollPhase.from_value(LibQt6.qt6cr_graphics_scene_wheel_event_phase(to_unsafe))
    end

    def phase=(value : ScrollPhase) : ScrollPhase
      LibQt6.qt6cr_graphics_scene_wheel_event_set_phase(to_unsafe, value.value)
      value
    end

    def pixel_delta : Point
      Point.from_native(LibQt6.qt6cr_graphics_scene_wheel_event_pixel_delta(to_unsafe))
    end

    def pixel_delta=(value : Point) : Point
      LibQt6.qt6cr_graphics_scene_wheel_event_set_pixel_delta(to_unsafe, value.to_native)
      value
    end

    def inverted? : Bool
      LibQt6.qt6cr_graphics_scene_wheel_event_is_inverted(to_unsafe)
    end

    def inverted=(value : Bool) : Bool
      LibQt6.qt6cr_graphics_scene_wheel_event_set_inverted(to_unsafe, value)
      value
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_graphics_scene_wheel_event_destroy(to_unsafe)
    end
  end
end
