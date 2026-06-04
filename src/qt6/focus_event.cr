module Qt6
  class FocusEvent < QEvent
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(type : EventType, reason : FocusReason = FocusReason::OtherFocusReason)
      super(LibQt6.qt6cr_focus_event_create(type.value, reason.value), true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def got_focus? : Bool
      LibQt6.qt6cr_focus_event_got_focus(to_unsafe)
    end

    def lost_focus? : Bool
      LibQt6.qt6cr_focus_event_lost_focus(to_unsafe)
    end

    def reason : FocusReason
      FocusReason.from_value(LibQt6.qt6cr_focus_event_reason(to_unsafe))
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_focus_event_destroy(to_unsafe)
    end
  end
end
