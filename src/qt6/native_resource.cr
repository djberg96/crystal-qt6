module Qt6
  abstract class NativeResource
    include ManagedResource

    getter to_unsafe : LibQt6::Handle
    @owned : Bool
    @destroyed = false

    protected def initialize(@to_unsafe : LibQt6::Handle, @owned : Bool = true)
      Qt6.track_object(self) if @owned
    end

    # Explicitly releases the wrapped native resource when this wrapper owns it.
    def release : Nil
      return if @destroyed || !@owned

      destroy_native
      mark_destroyed
    end

    # Returns `true` after the native resource has been released.
    def destroyed? : Bool
      @destroyed
    end

    protected def mark_destroyed : Nil
      return if @destroyed

      @destroyed = true
      Qt6.untrack_object(self)
    end

    protected abstract def destroy_native : Nil
  end
end