module Qt6
  class ScrollEvent < QEvent
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(content_pos : PointF, overshoot_distance : PointF, scroll_state : ScrollState)
      super(LibQt6.qt6cr_scroll_event_create(content_pos.to_native, overshoot_distance.to_native, scroll_state.value), true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def content_pos : PointF
      PointF.from_native(LibQt6.qt6cr_scroll_event_content_pos(to_unsafe))
    end

    def overshoot_distance : PointF
      PointF.from_native(LibQt6.qt6cr_scroll_event_overshoot_distance(to_unsafe))
    end

    def scroll_state : ScrollState
      ScrollState.from_value(LibQt6.qt6cr_scroll_event_scroll_state(to_unsafe))
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_scroll_event_destroy(to_unsafe)
    end
  end
end
