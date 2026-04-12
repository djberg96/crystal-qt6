module Qt6
  # Wraps `QEventLoop` for nested local event processing.
  class QEventLoop < QObject
    # Creates an event loop, optionally parented to another `QObject`.
    def initialize(parent : QObject? = nil)
      super(LibQt6.qt6cr_event_loop_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    # Enters the event loop and blocks until `quit` or `exit` is called.
    def run : Int32
      LibQt6.qt6cr_event_loop_exec(to_unsafe)
    end

    # Requests that the event loop exit with return code `0`.
    def quit : self
      LibQt6.qt6cr_event_loop_quit(to_unsafe)
      self
    end

    # Requests that the event loop exit with the given return code.
    def exit(return_code : Int = 0) : Int32
      LibQt6.qt6cr_event_loop_exit(to_unsafe, return_code)
      return_code.to_i32
    end

    # Processes pending events without entering the blocking loop.
    def process_events : self
      LibQt6.qt6cr_event_loop_process_events(to_unsafe)
      self
    end

    # Returns `true` while the loop is currently running.
    def running? : Bool
      LibQt6.qt6cr_event_loop_is_running(to_unsafe)
    end
  end
end
