module Qt6
  class IconDragEvent < QEvent
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize
      super(LibQt6.qt6cr_icon_drag_event_create, true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_icon_drag_event_destroy(to_unsafe)
    end
  end
end
