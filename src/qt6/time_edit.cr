module Qt6
  # Wraps `QTimeEdit`.
  class TimeEdit < DateTimeEdit
    @time_changed : Signal(QTime) = Signal(QTime).new
    @user_time_changed : Signal(QTime) = Signal(QTime).new
    @time_callback_userdata : LibQt6::Handle = Pointer(Void).null
    @user_time_callback_userdata : LibQt6::Handle = Pointer(Void).null

    getter time_changed : Signal(QTime)
    getter user_time_changed : Signal(QTime)

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_time_edit_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      install_time_callbacks
    end

    def initialize(time : QTime, parent : Widget? = nil)
      super(LibQt6.qt6cr_time_edit_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      install_time_callbacks
      self.time = time
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      install_time_callbacks
    end

    def on_time_changed(&block : QTime ->) : self
      @time_changed.connect { |value| block.call(value) }
      self
    end

    def on_user_time_changed(&block : QTime ->) : self
      @user_time_changed.connect { |value| block.call(value) }
      self
    end

    protected def emit_time_changed(handle : LibQt6::Handle) : Nil
      @time_changed.emit(QTime.wrap(handle, true))
    end

    protected def emit_user_time_changed(handle : LibQt6::Handle) : Nil
      @user_time_changed.emit(QTime.wrap(handle, true))
    end

    private def install_time_callbacks : Nil
      @time_changed = Signal(QTime).new
      @user_time_changed = Signal(QTime).new
      @time_callback_userdata = Box.box(self)
      @user_time_callback_userdata = Box.box(self)
      LibQt6.qt6cr_time_edit_on_time_changed(to_unsafe, TIME_CHANGED_TRAMPOLINE, @time_callback_userdata)
      LibQt6.qt6cr_time_edit_on_user_time_changed(to_unsafe, USER_TIME_CHANGED_TRAMPOLINE, @user_time_callback_userdata)
    end

    private TIME_CHANGED_TRAMPOLINE = ->(userdata : Void*, handle : Void*) do
      Box(TimeEdit).unbox(userdata).emit_time_changed(handle)
    end

    private USER_TIME_CHANGED_TRAMPOLINE = ->(userdata : Void*, handle : Void*) do
      Box(TimeEdit).unbox(userdata).emit_user_time_changed(handle)
    end
  end
end
