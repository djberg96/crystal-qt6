module Qt6
  # Wraps a callback-backed event filter for widgets.
  class EventFilter < QObject
    @event_callback : Proc(Widget?, QEvent, Bool)? = nil
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    def initialize(parent : QObject? = nil)
      super(LibQt6.qt6cr_event_filter_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      @callback_userdata = Box.box(self)
    end

    # Registers a block that can inspect and optionally consume widget events.
    def on_event(&block : Widget?, QEvent -> Bool) : self
      @event_callback = block
      LibQt6.qt6cr_event_filter_on_event(to_unsafe, EVENT_TRAMPOLINE, @callback_userdata)
      self
    end

    protected def filter_event(watched_handle : LibQt6::Handle, event_handle : LibQt6::Handle) : Bool
      callback = @event_callback
      return false unless callback

      watched = watched_handle.null? ? nil : Widget.wrap(watched_handle)
      callback.call(watched, QEvent.new(event_handle))
    end

    private EVENT_TRAMPOLINE = ->(userdata : Void*, watched_handle : Void*, event_handle : Void*) do
      Box(EventFilter).unbox(userdata).filter_event(watched_handle, event_handle)
    end
  end
end
