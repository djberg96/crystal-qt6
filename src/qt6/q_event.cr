module Qt6
  # Wraps a live `QEvent` during event-filter callbacks.
  #
  # The underlying event handle is only valid while the callback is running.
  class QEvent
    getter to_unsafe : LibQt6::Handle

    def initialize(@to_unsafe : LibQt6::Handle)
    end

    # Returns the raw Qt event type integer.
    def type_value : Int32
      LibQt6.qt6cr_event_type(to_unsafe)
    end

    # Returns the Qt event type when it maps to a known enum value.
    def type : EventType?
      EventType.values.find { |value| value.value == type_value }
    end

    # Marks the event as accepted.
    def accept : self
      LibQt6.qt6cr_event_accept(to_unsafe)
      self
    end

    # Marks the event as ignored.
    def ignore : self
      LibQt6.qt6cr_event_ignore(to_unsafe)
      self
    end

    # Returns whether the event is currently accepted.
    def accepted? : Bool
      LibQt6.qt6cr_event_is_accepted(to_unsafe)
    end
  end
end
