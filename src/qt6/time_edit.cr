module Qt6
  # Wraps `QTimeEdit`.
  class TimeEdit < DateTimeEdit
    @time_changed : Signal(QTime) = Signal(QTime).new
    @time_callback_userdata : LibQt6::Handle = Pointer(Void).null

    getter time_changed : Signal(QTime)

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_time_edit_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      @time_changed = Signal(QTime).new
      @time_callback_userdata = Box.box(self)
      LibQt6.qt6cr_time_edit_on_time_changed(to_unsafe, TIME_CHANGED_TRAMPOLINE, @time_callback_userdata)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      @time_changed = Signal(QTime).new
      @time_callback_userdata = Box.box(self)
      LibQt6.qt6cr_time_edit_on_time_changed(to_unsafe, TIME_CHANGED_TRAMPOLINE, @time_callback_userdata)
    end

    def on_time_changed(&block : QTime ->) : self
      @time_changed.connect { |value| block.call(value) }
      self
    end

    protected def emit_time_changed(handle : LibQt6::Handle) : Nil
      @time_changed.emit(QTime.wrap(handle, true))
    end

    private TIME_CHANGED_TRAMPOLINE = ->(userdata : Void*, handle : Void*) do
      Box(TimeEdit).unbox(userdata).emit_time_changed(handle)
    end
  end
end
