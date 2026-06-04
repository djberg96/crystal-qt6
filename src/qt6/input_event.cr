module Qt6
  class InputEvent < QEvent
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def modifiers : KeyboardModifier
      KeyboardModifier.from_value(LibQt6.qt6cr_input_event_modifiers(to_unsafe))
    end

    def modifiers=(value : KeyboardModifier) : KeyboardModifier
      LibQt6.qt6cr_input_event_set_modifiers(to_unsafe, value.value)
      value
    end

    def set_modifiers(value : KeyboardModifier) : self
      self.modifiers = value
      self
    end

    def timestamp : UInt64
      LibQt6.qt6cr_input_event_timestamp(to_unsafe)
    end

    def timestamp=(value : Int) : UInt64
      timestamp = value.to_u64
      LibQt6.qt6cr_input_event_set_timestamp(to_unsafe, timestamp)
      timestamp
    end

    def device_type_value : Int32
      LibQt6.qt6cr_input_event_device_type(to_unsafe)
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_event_destroy(to_unsafe)
    end
  end
end
