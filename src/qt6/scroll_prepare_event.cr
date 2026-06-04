module Qt6
  class ScrollPrepareEvent < QEvent
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(start_pos : PointF)
      super(LibQt6.qt6cr_scroll_prepare_event_create(start_pos.to_native), true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def start_pos : PointF
      PointF.from_native(LibQt6.qt6cr_scroll_prepare_event_start_pos(to_unsafe))
    end

    def viewport_size : SizeF
      SizeF.from_native(LibQt6.qt6cr_scroll_prepare_event_viewport_size(to_unsafe))
    end

    def viewport_size=(value : SizeF) : SizeF
      LibQt6.qt6cr_scroll_prepare_event_set_viewport_size(to_unsafe, value.to_native)
      value
    end

    def content_pos_range : RectF
      RectF.from_native(LibQt6.qt6cr_scroll_prepare_event_content_pos_range(to_unsafe))
    end

    def content_pos_range=(value : RectF) : RectF
      LibQt6.qt6cr_scroll_prepare_event_set_content_pos_range(to_unsafe, value.to_native)
      value
    end

    def content_pos : PointF
      PointF.from_native(LibQt6.qt6cr_scroll_prepare_event_content_pos(to_unsafe))
    end

    def content_pos=(value : PointF) : PointF
      LibQt6.qt6cr_scroll_prepare_event_set_content_pos(to_unsafe, value.to_native)
      value
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_scroll_prepare_event_destroy(to_unsafe)
    end
  end
end
