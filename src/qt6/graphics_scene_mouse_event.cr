module Qt6
  # Wraps `QGraphicsSceneMouseEvent` for synthetic or live graphics-scene mouse inspection.
  #
  # When obtained from `QEvent#graphics_scene_mouse_event`, the underlying handle is only
  # valid while the surrounding callback is running.
  class GraphicsSceneMouseEvent < GraphicsSceneEvent
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a graphics-scene mouse event with an optional event type.
    def initialize(type : EventType = EventType::GraphicsSceneMouseMove)
      super(LibQt6.qt6cr_graphics_scene_mouse_event_create(type.value), true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def pos : PointF
      PointF.from_native(LibQt6.qt6cr_graphics_scene_mouse_event_pos(to_unsafe))
    end

    def pos=(value : PointF) : PointF
      LibQt6.qt6cr_graphics_scene_mouse_event_set_pos(to_unsafe, value.to_native)
      value
    end

    def scene_pos : PointF
      PointF.from_native(LibQt6.qt6cr_graphics_scene_mouse_event_scene_pos(to_unsafe))
    end

    def scene_pos=(value : PointF) : PointF
      LibQt6.qt6cr_graphics_scene_mouse_event_set_scene_pos(to_unsafe, value.to_native)
      value
    end

    def screen_pos : Point
      Point.from_native(LibQt6.qt6cr_graphics_scene_mouse_event_screen_pos(to_unsafe))
    end

    def screen_pos=(value : Point) : Point
      LibQt6.qt6cr_graphics_scene_mouse_event_set_screen_pos(to_unsafe, value.to_native)
      value
    end

    def button_down_pos(button : Int) : PointF
      PointF.from_native(LibQt6.qt6cr_graphics_scene_mouse_event_button_down_pos(to_unsafe, button.to_i32))
    end

    def set_button_down_pos(button : Int, value : PointF) : PointF
      LibQt6.qt6cr_graphics_scene_mouse_event_set_button_down_pos(to_unsafe, button.to_i32, value.to_native)
      value
    end

    def button_down_scene_pos(button : Int) : PointF
      PointF.from_native(LibQt6.qt6cr_graphics_scene_mouse_event_button_down_scene_pos(to_unsafe, button.to_i32))
    end

    def set_button_down_scene_pos(button : Int, value : PointF) : PointF
      LibQt6.qt6cr_graphics_scene_mouse_event_set_button_down_scene_pos(to_unsafe, button.to_i32, value.to_native)
      value
    end

    def button_down_screen_pos(button : Int) : Point
      Point.from_native(LibQt6.qt6cr_graphics_scene_mouse_event_button_down_screen_pos(to_unsafe, button.to_i32))
    end

    def set_button_down_screen_pos(button : Int, value : Point) : Point
      LibQt6.qt6cr_graphics_scene_mouse_event_set_button_down_screen_pos(to_unsafe, button.to_i32, value.to_native)
      value
    end

    def last_pos : PointF
      PointF.from_native(LibQt6.qt6cr_graphics_scene_mouse_event_last_pos(to_unsafe))
    end

    def last_pos=(value : PointF) : PointF
      LibQt6.qt6cr_graphics_scene_mouse_event_set_last_pos(to_unsafe, value.to_native)
      value
    end

    def last_scene_pos : PointF
      PointF.from_native(LibQt6.qt6cr_graphics_scene_mouse_event_last_scene_pos(to_unsafe))
    end

    def last_scene_pos=(value : PointF) : PointF
      LibQt6.qt6cr_graphics_scene_mouse_event_set_last_scene_pos(to_unsafe, value.to_native)
      value
    end

    def last_screen_pos : Point
      Point.from_native(LibQt6.qt6cr_graphics_scene_mouse_event_last_screen_pos(to_unsafe))
    end

    def last_screen_pos=(value : Point) : Point
      LibQt6.qt6cr_graphics_scene_mouse_event_set_last_screen_pos(to_unsafe, value.to_native)
      value
    end

    def buttons : Int32
      LibQt6.qt6cr_graphics_scene_mouse_event_buttons(to_unsafe)
    end

    def buttons=(value : Int) : Int32
      buttons = value.to_i32
      LibQt6.qt6cr_graphics_scene_mouse_event_set_buttons(to_unsafe, buttons)
      buttons
    end

    def button : Int32
      LibQt6.qt6cr_graphics_scene_mouse_event_button(to_unsafe)
    end

    def button=(value : Int) : Int32
      button = value.to_i32
      LibQt6.qt6cr_graphics_scene_mouse_event_set_button(to_unsafe, button)
      button
    end

    def modifiers : Int32
      LibQt6.qt6cr_graphics_scene_mouse_event_modifiers(to_unsafe)
    end

    def modifiers=(value : Int) : Int32
      modifiers = value.to_i32
      LibQt6.qt6cr_graphics_scene_mouse_event_set_modifiers(to_unsafe, modifiers)
      modifiers
    end

    def source : Int32
      LibQt6.qt6cr_graphics_scene_mouse_event_source(to_unsafe)
    end

    def source=(value : Int) : Int32
      source = value.to_i32
      LibQt6.qt6cr_graphics_scene_mouse_event_set_source(to_unsafe, source)
      source
    end

    def flags : Int32
      LibQt6.qt6cr_graphics_scene_mouse_event_flags(to_unsafe)
    end

    def flags=(value : Int) : Int32
      flags = value.to_i32
      LibQt6.qt6cr_graphics_scene_mouse_event_set_flags(to_unsafe, flags)
      flags
    end
  end
end
