module Qt6
  class PlatformSurfaceEvent < QEvent
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(surface_event_type : PlatformSurfaceEventType)
      super(LibQt6.qt6cr_platform_surface_event_create(surface_event_type.value), true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def surface_event_type : PlatformSurfaceEventType
      PlatformSurfaceEventType.from_value(LibQt6.qt6cr_platform_surface_event_surface_event_type(to_unsafe))
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_platform_surface_event_destroy(to_unsafe)
    end
  end
end
