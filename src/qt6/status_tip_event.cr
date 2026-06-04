module Qt6
  class StatusTipEvent < QEvent
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(tip : String)
      super(LibQt6.qt6cr_status_tip_event_create(tip.to_unsafe), true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def tip : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_status_tip_event_tip(to_unsafe))
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_status_tip_event_destroy(to_unsafe)
    end
  end
end
