module Qt6
  class ExposeEvent < QEvent
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(region : QRegion = QRegion.new)
      super(LibQt6.qt6cr_expose_event_create(region.to_unsafe), true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def region : QRegion
      QRegion.wrap(LibQt6.qt6cr_expose_event_region(to_unsafe), true)
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_expose_event_destroy(to_unsafe)
    end
  end
end
