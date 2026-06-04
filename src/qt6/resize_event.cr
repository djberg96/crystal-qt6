module Qt6
  class ResizeEvent < QEvent
    @copied_old_size : Size?
    @copied_size : Size?

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Preserves the lightweight copied payload used by `EventWidget` callbacks.
    def initialize(old_size : Size, size : Size)
      @copied_old_size = old_size
      @copied_size = size
      super(Pointer(Void).null, false)
    end

    def self.from_sizes(size : Size, old_size : Size) : self
      wrap(LibQt6.qt6cr_resize_event_create(size.to_native, old_size.to_native), true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      @copied_old_size = nil
      @copied_size = nil
      super(handle, owned)
    end

    def old_size : Size
      if copied = @copied_old_size
        copied
      else
        Size.from_native(LibQt6.qt6cr_resize_event_old_size(to_unsafe))
      end
    end

    def size : Size
      if copied = @copied_size
        copied
      else
        Size.from_native(LibQt6.qt6cr_resize_event_size(to_unsafe))
      end
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_resize_event_destroy(to_unsafe)
    end
  end
end
