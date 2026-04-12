module Qt6
  # Wraps a live drag/drop event during `EventWidget` callbacks.
  #
  # The underlying event handle is only valid while the callback is running.
  class DropEvent
    getter to_unsafe : LibQt6::Handle

    def initialize(@to_unsafe : LibQt6::Handle)
    end

    # Returns the event position in widget-local coordinates.
    def position : PointF
      PointF.from_native(LibQt6.qt6cr_drop_event_position(to_unsafe))
    end

    # Returns the pressed mouse buttons bitmask.
    def buttons : Int32
      LibQt6.qt6cr_drop_event_buttons(to_unsafe)
    end

    # Returns the keyboard modifiers bitmask.
    def modifiers : Int32
      LibQt6.qt6cr_drop_event_modifiers(to_unsafe)
    end

    # Returns the event payload, if any.
    def mime_data : MimeData?
      handle = LibQt6.qt6cr_drop_event_mime_data(to_unsafe)
      handle.null? ? nil : MimeData.wrap(handle)
    end

    # Marks the event as accepted.
    def accept : self
      LibQt6.qt6cr_drop_event_accept(to_unsafe)
      self
    end

    # Accepts the event using Qt's proposed action.
    def accept_proposed_action : self
      LibQt6.qt6cr_drop_event_accept_proposed_action(to_unsafe)
      self
    end

    # Marks the event as ignored.
    def ignore : self
      LibQt6.qt6cr_drop_event_ignore(to_unsafe)
      self
    end

    # Returns whether the event is currently accepted.
    def accepted? : Bool
      LibQt6.qt6cr_drop_event_is_accepted(to_unsafe)
    end
  end
end
