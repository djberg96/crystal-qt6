module Qt6
  class ShowEvent < QEvent
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize
      super(LibQt6.qt6cr_show_event_create, true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_show_event_destroy(to_unsafe)
    end
  end
end
