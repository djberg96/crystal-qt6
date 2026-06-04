module Qt6
  class DynamicPropertyChangeEvent < QEvent
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(name : String)
      super(LibQt6.qt6cr_dynamic_property_change_event_create(name.to_unsafe), true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def property_name : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_dynamic_property_change_event_property_name(to_unsafe))
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_dynamic_property_change_event_destroy(to_unsafe)
    end
  end
end
