module Qt6
  # Wraps `QGraphicsSceneDragDropEvent` for synthetic or live graphics-scene drag/drop inspection.
  #
  # When obtained from `QEvent#graphics_scene_drag_drop_event`, the underlying handle is
  # only valid while the surrounding callback is running.
  class GraphicsSceneDragDropEvent < NativeResource
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a graphics-scene drag/drop event with an optional event type.
    def initialize(type : EventType = EventType::GraphicsSceneDragEnter)
      super(LibQt6.qt6cr_graphics_scene_drag_drop_event_create(type.value))
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
      handle = LibQt6.qt6cr_graphics_scene_drag_drop_event_widget(to_unsafe)
      handle.null? ? nil : Widget.wrap(handle)
    end

    def widget=(value : Widget?) : Widget?
      LibQt6.qt6cr_graphics_scene_drag_drop_event_set_widget(to_unsafe, value.try(&.to_unsafe) || Pointer(Void).null)
      value
    end

    def set_widget(value : Widget?) : self
      self.widget = value
      self
    end

    def timestamp : UInt64
      LibQt6.qt6cr_graphics_scene_drag_drop_event_timestamp(to_unsafe).to_u64
    end

    def timestamp=(value : Int) : UInt64
      timestamp = value.to_u64
      LibQt6.qt6cr_graphics_scene_drag_drop_event_set_timestamp(to_unsafe, timestamp)
      timestamp
    end

    def pos : PointF
      PointF.from_native(LibQt6.qt6cr_graphics_scene_drag_drop_event_pos(to_unsafe))
    end

    def pos=(value : PointF) : PointF
      LibQt6.qt6cr_graphics_scene_drag_drop_event_set_pos(to_unsafe, value.to_native)
      value
    end

    def scene_pos : PointF
      PointF.from_native(LibQt6.qt6cr_graphics_scene_drag_drop_event_scene_pos(to_unsafe))
    end

    def scene_pos=(value : PointF) : PointF
      LibQt6.qt6cr_graphics_scene_drag_drop_event_set_scene_pos(to_unsafe, value.to_native)
      value
    end

    def screen_pos : Point
      Point.from_native(LibQt6.qt6cr_graphics_scene_drag_drop_event_screen_pos(to_unsafe))
    end

    def screen_pos=(value : Point) : Point
      LibQt6.qt6cr_graphics_scene_drag_drop_event_set_screen_pos(to_unsafe, value.to_native)
      value
    end

    def buttons : Int32
      LibQt6.qt6cr_graphics_scene_drag_drop_event_buttons(to_unsafe)
    end

    def buttons=(value : Int) : Int32
      buttons = value.to_i32
      LibQt6.qt6cr_graphics_scene_drag_drop_event_set_buttons(to_unsafe, buttons)
      buttons
    end

    def modifiers : Int32
      LibQt6.qt6cr_graphics_scene_drag_drop_event_modifiers(to_unsafe)
    end

    def modifiers=(value : Int) : Int32
      modifiers = value.to_i32
      LibQt6.qt6cr_graphics_scene_drag_drop_event_set_modifiers(to_unsafe, modifiers)
      modifiers
    end

    def possible_actions : DropAction
      DropAction.from_value(LibQt6.qt6cr_graphics_scene_drag_drop_event_possible_actions(to_unsafe))
    end

    def possible_actions=(value : DropAction) : DropAction
      LibQt6.qt6cr_graphics_scene_drag_drop_event_set_possible_actions(to_unsafe, value.value)
      value
    end

    def proposed_action : DropAction
      DropAction.from_value(LibQt6.qt6cr_graphics_scene_drag_drop_event_proposed_action(to_unsafe))
    end

    def proposed_action=(value : DropAction) : DropAction
      LibQt6.qt6cr_graphics_scene_drag_drop_event_set_proposed_action(to_unsafe, value.value)
      value
    end

    def accept_proposed_action : self
      LibQt6.qt6cr_graphics_scene_drag_drop_event_accept_proposed_action(to_unsafe)
      self
    end

    def drop_action : DropAction
      DropAction.from_value(LibQt6.qt6cr_graphics_scene_drag_drop_event_drop_action(to_unsafe))
    end

    def drop_action=(value : DropAction) : DropAction
      LibQt6.qt6cr_graphics_scene_drag_drop_event_set_drop_action(to_unsafe, value.value)
      value
    end

    def source : Widget?
      handle = LibQt6.qt6cr_graphics_scene_drag_drop_event_source(to_unsafe)
      handle.null? ? nil : Widget.wrap(handle)
    end

    def source=(value : Widget?) : Widget?
      LibQt6.qt6cr_graphics_scene_drag_drop_event_set_source(to_unsafe, value.try(&.to_unsafe) || Pointer(Void).null)
      value
    end

    def set_source(value : Widget?) : self
      self.source = value
      self
    end

    def mime_data : MimeData?
      handle = LibQt6.qt6cr_graphics_scene_drag_drop_event_mime_data(to_unsafe)
      handle.null? ? nil : MimeData.wrap(handle)
    end

    def mime_data=(value : MimeData?) : MimeData?
      LibQt6.qt6cr_graphics_scene_drag_drop_event_set_mime_data(to_unsafe, value.try(&.to_unsafe) || Pointer(Void).null)
      value
    end

    def set_mime_data(value : MimeData?) : self
      self.mime_data = value
      self
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_graphics_scene_drag_drop_event_destroy(to_unsafe)
    end
  end
end
