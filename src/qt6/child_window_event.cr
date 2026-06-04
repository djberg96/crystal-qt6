module Qt6
  class ChildWindowEvent < QEvent
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(type : EventType, child : QObject? = nil)
      super(LibQt6.qt6cr_child_window_event_create(type.value, child.try(&.to_unsafe) || Pointer(Void).null), true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def child : QObject?
      handle = LibQt6.qt6cr_child_window_event_child(to_unsafe)
      handle.null? ? nil : QObject.wrap(handle)
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_child_window_event_destroy(to_unsafe)
    end
  end
end
