module Qt6
  class QObject
    getter to_unsafe : LibQt6::Handle
    @destroyed_signal : Signal() = Signal().new
    @owned : Bool = false
    @destroyed = false
    @destroyed_userdata : LibQt6::Handle = Pointer(Void).null

    protected def initialize(@to_unsafe : LibQt6::Handle, @owned : Bool)
      @destroyed_signal = Signal().new
      @destroyed_userdata = Box.box(self.as(QObject))
      LibQt6.qt6cr_object_on_destroyed(@to_unsafe, OBJECT_DESTROYED_TRAMPOLINE, @destroyed_userdata)
      Qt6.track_object(self) if @owned
    end

    def release : Nil
      return if @destroyed || !@owned

      LibQt6.qt6cr_object_destroy(@to_unsafe)
    end

    def destroyed? : Bool
      @destroyed
    end

    def destroyed : Signal()
      @destroyed_signal
    end

    protected def mark_destroyed_from_qt : Nil
      return if @destroyed

      @destroyed = true
      Qt6.untrack_object(self)
      @destroyed_signal.emit
    end

    private OBJECT_DESTROYED_TRAMPOLINE = ->(userdata : Void*) do
      Box(QObject).unbox(userdata).mark_destroyed_from_qt
    end
  end
end
