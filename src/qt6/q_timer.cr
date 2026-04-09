module Qt6
  # Wraps `QTimer`.
  class QTimer < QObject
    @timeout : Signal() = Signal().new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    # Signal emitted whenever the timer times out.
    getter timeout : Signal()

    # Creates a timer, optionally parented to another `QObject`.
    def initialize(parent : QObject? = nil)
      super(LibQt6.qt6cr_timer_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      @timeout = Signal().new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_timer_on_timeout(to_unsafe, TIMEOUT_TRAMPOLINE, @callback_userdata)
    end

    # Returns the timer interval in milliseconds.
    def interval : Int32
      LibQt6.qt6cr_timer_interval(to_unsafe)
    end

    # Sets the interval in milliseconds and returns the assigned value.
    def interval=(value : Int) : Int32
      LibQt6.qt6cr_timer_set_interval(to_unsafe, value)
      value.to_i
    end

    # Returns `true` when the timer is single-shot.
    def single_shot? : Bool
      LibQt6.qt6cr_timer_is_single_shot(to_unsafe)
    end

    # Enables or disables single-shot mode.
    def single_shot=(value : Bool) : Bool
      LibQt6.qt6cr_timer_set_single_shot(to_unsafe, value)
      value
    end

    # Returns `true` when the timer is active.
    def active? : Bool
      LibQt6.qt6cr_timer_is_active(to_unsafe)
    end

    # Starts the timer, optionally updating the interval first.
    def start(interval : Int? = nil) : self
      self.interval = interval.not_nil! if interval
      LibQt6.qt6cr_timer_start(to_unsafe)
      self
    end

    # Stops the timer.
    def stop : self
      LibQt6.qt6cr_timer_stop(to_unsafe)
      self
    end

    # Registers a block to run when the timer times out.
    def on_timeout(&block : ->) : self
      @timeout.connect { block.call }
      self
    end

    protected def emit_timeout : Nil
      @timeout.emit
    end

    private TIMEOUT_TRAMPOLINE = ->(userdata : Void*) do
      Box(QTimer).unbox(userdata).emit_timeout
    end
  end
end
