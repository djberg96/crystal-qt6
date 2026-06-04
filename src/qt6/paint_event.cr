module Qt6
  class PaintEvent < QEvent
    @copied_rect : RectF?

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Preserves the lightweight copied payload used by `EventWidget` callbacks.
    def initialize(rect : RectF)
      @copied_rect = rect
      super(Pointer(Void).null, false)
    end

    def initialize(rect : Rect)
      @copied_rect = nil
      super(LibQt6.qt6cr_paint_event_create_rect(rect.to_native))
    end

    def initialize(region : QRegion)
      @copied_rect = nil
      super(LibQt6.qt6cr_paint_event_create_region(region.to_unsafe))
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      @copied_rect = nil
      super(handle, owned)
    end

    def rect : RectF
      if copied = @copied_rect
        copied
      else
        Rect.from_native(LibQt6.qt6cr_paint_event_rect(to_unsafe)).to_rect_f
      end
    end

    def region : QRegion
      handle = LibQt6.qt6cr_paint_event_region(to_unsafe)
      handle.null? ? QRegion.new : QRegion.wrap(handle, true)
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_paint_event_destroy(to_unsafe)
    end
  end
end
