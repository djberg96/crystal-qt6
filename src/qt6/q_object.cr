module Qt6
  # Base wrapper for owned Qt objects.
  #
  # This class is responsible for deterministic teardown and for surfacing the
  # native `destroyed` signal into Crystal.
  class QObject
    include ManagedResource

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

    # Explicitly releases the wrapped native object when this wrapper owns it.
    def release : Nil
      return if @destroyed || !@owned

      LibQt6.qt6cr_object_destroy(@to_unsafe)
    end

    # Returns `true` after Qt has destroyed the native object.
    def destroyed? : Bool
      @destroyed
    end

    # Emits when the underlying Qt object is destroyed.
    def destroyed : Signal()
      @destroyed_signal
    end

    # Blocks or unblocks this object's signal emissions.
    def block_signals=(value : Bool) : Bool
      LibQt6.qt6cr_object_block_signals(@to_unsafe, value)
    end

    # Returns `true` when signal delivery is currently blocked.
    def signals_blocked? : Bool
      LibQt6.qt6cr_object_signals_blocked(@to_unsafe)
    end

    # Marks this object as owned by a native parent so the wrapper stops trying
    # to release it directly.
    def adopt_by_parent! : Nil
      return unless @owned

      Qt6.untrack_object(self)
      @owned = false
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
