module Qt6
  # Wraps `QGraphicsSceneEvent` for shared scene-event state and live reinterpretation.
  #
  # When obtained from `QEvent#graphics_scene_event`, the underlying handle is only valid
  # while the surrounding callback is running.
  class GraphicsSceneEvent < NativeResource
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a graphics-scene event with the given type.
    def initialize(type : EventType = EventType::None)
      super(LibQt6.qt6cr_graphics_scene_event_create(type.value))
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
      handle = LibQt6.qt6cr_graphics_scene_event_widget(to_unsafe)
      handle.null? ? nil : Widget.wrap(handle)
    end

    def widget=(value : Widget?) : Widget?
      LibQt6.qt6cr_graphics_scene_event_set_widget(to_unsafe, value.try(&.to_unsafe) || Pointer(Void).null)
      value
    end

    def set_widget(value : Widget?) : self
      self.widget = value
      self
    end

    def timestamp : UInt64
      LibQt6.qt6cr_graphics_scene_event_timestamp(to_unsafe).to_u64
    end

    def timestamp=(value : Int) : UInt64
      timestamp = value.to_u64
      LibQt6.qt6cr_graphics_scene_event_set_timestamp(to_unsafe, timestamp)
      timestamp
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_graphics_scene_event_destroy(to_unsafe)
    end
  end
end
