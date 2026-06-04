module Qt6
  class TimerEvent < QEvent
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(timer_id : Int)
      super(LibQt6.qt6cr_timer_event_create(timer_id.to_i32), true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def timer_id : Int32
      LibQt6.qt6cr_timer_event_timer_id(to_unsafe)
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_timer_event_destroy(to_unsafe)
    end
  end
end
