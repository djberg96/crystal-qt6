module Qt6
  class WindowStateChangeEvent < QEvent
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(old_state : WindowState, is_override : Bool = false)
      super(LibQt6.qt6cr_window_state_change_event_create(old_state.value, is_override), true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def old_state : WindowState
      WindowState.from_value(LibQt6.qt6cr_window_state_change_event_old_state(to_unsafe))
    end

    def override? : Bool
      LibQt6.qt6cr_window_state_change_event_is_override(to_unsafe)
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_window_state_change_event_destroy(to_unsafe)
    end
  end
end
