module Qt6
  class HelpEvent < QEvent
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(type : EventType, pos : Point, global_pos : Point)
      super(LibQt6.qt6cr_help_event_create(type.value, pos.to_native, global_pos.to_native), true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def pos : Point
      Point.from_native(LibQt6.qt6cr_help_event_pos(to_unsafe))
    end

    def global_pos : Point
      Point.from_native(LibQt6.qt6cr_help_event_global_pos(to_unsafe))
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_help_event_destroy(to_unsafe)
    end
  end
end
