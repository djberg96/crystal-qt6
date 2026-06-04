module Qt6
  class ActionEvent < QEvent
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(type : EventType, action : Action, before : Action? = nil)
      super(LibQt6.qt6cr_action_event_create(type.value, action.to_unsafe, before.try(&.to_unsafe) || Pointer(Void).null), true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def action : Action?
      handle = LibQt6.qt6cr_action_event_action(to_unsafe)
      handle.null? ? nil : Action.wrap(handle)
    end

    def before : Action?
      handle = LibQt6.qt6cr_action_event_before(to_unsafe)
      handle.null? ? nil : Action.wrap(handle)
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_action_event_destroy(to_unsafe)
    end
  end
end
