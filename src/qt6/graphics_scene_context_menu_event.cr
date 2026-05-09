module Qt6
  # Wraps `QGraphicsSceneContextMenuEvent` for synthetic or live scene-context-menu inspection.
  #
  # When obtained from `QEvent#graphics_scene_context_menu_event`, the underlying handle is
  # only valid while the surrounding callback is running.
  class GraphicsSceneContextMenuEvent < NativeResource
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a graphics-scene context-menu event with an optional event type.
    def initialize(type : EventType = EventType::GraphicsSceneContextMenu)
      super(LibQt6.qt6cr_graphics_scene_context_menu_event_create(type.value))
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def type_value : Int32
      LibQt6.qt6cr_event_type(to_unsafe)
    end

    def type : EventType?
      EventType.values.find { |value| value.value == type_value }
    end

    def accept : self
      LibQt6.qt6cr_event_accept(to_unsafe)
      self
    end

    def ignore : self
      LibQt6.qt6cr_event_ignore(to_unsafe)
      self
    end

    def accepted? : Bool
      LibQt6.qt6cr_event_is_accepted(to_unsafe)
    end

    def widget : Widget?
      handle = LibQt6.qt6cr_graphics_scene_context_menu_event_widget(to_unsafe)
      handle.null? ? nil : Widget.wrap(handle)
    end

    def widget=(value : Widget?) : Widget?
      LibQt6.qt6cr_graphics_scene_context_menu_event_set_widget(to_unsafe, value.try(&.to_unsafe) || Pointer(Void).null)
      value
    end

    def set_widget(value : Widget?) : self
      self.widget = value
      self
    end

    def timestamp : UInt64
      LibQt6.qt6cr_graphics_scene_context_menu_event_timestamp(to_unsafe).to_u64
    end

    def timestamp=(value : Int) : UInt64
      timestamp = value.to_u64
      LibQt6.qt6cr_graphics_scene_context_menu_event_set_timestamp(to_unsafe, timestamp)
      timestamp
    end

    def pos : PointF
      PointF.from_native(LibQt6.qt6cr_graphics_scene_context_menu_event_pos(to_unsafe))
    end

    def pos=(value : PointF) : PointF
      LibQt6.qt6cr_graphics_scene_context_menu_event_set_pos(to_unsafe, value.to_native)
      value
    end

    def scene_pos : PointF
      PointF.from_native(LibQt6.qt6cr_graphics_scene_context_menu_event_scene_pos(to_unsafe))
    end

    def scene_pos=(value : PointF) : PointF
      LibQt6.qt6cr_graphics_scene_context_menu_event_set_scene_pos(to_unsafe, value.to_native)
      value
    end

    def screen_pos : Point
      Point.from_native(LibQt6.qt6cr_graphics_scene_context_menu_event_screen_pos(to_unsafe))
    end

    def screen_pos=(value : Point) : Point
      LibQt6.qt6cr_graphics_scene_context_menu_event_set_screen_pos(to_unsafe, value.to_native)
      value
    end

    def modifiers : Int32
      LibQt6.qt6cr_graphics_scene_context_menu_event_modifiers(to_unsafe)
    end

    def modifiers=(value : Int) : Int32
      modifiers = value.to_i32
      LibQt6.qt6cr_graphics_scene_context_menu_event_set_modifiers(to_unsafe, modifiers)
      modifiers
    end

    def reason : GraphicsSceneContextMenuEventReason
      GraphicsSceneContextMenuEventReason.from_value(LibQt6.qt6cr_graphics_scene_context_menu_event_reason(to_unsafe))
    end

    def reason=(value : GraphicsSceneContextMenuEventReason) : GraphicsSceneContextMenuEventReason
      LibQt6.qt6cr_graphics_scene_context_menu_event_set_reason(to_unsafe, value.value)
      value
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_graphics_scene_context_menu_event_destroy(to_unsafe)
    end
  end
end
