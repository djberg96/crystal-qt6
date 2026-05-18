module Qt6
  # Wraps `QStyleHintReturn` for style-hint result payloads.
  class StyleHintReturn < NativeResource
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : StyleHintReturn
      case LibQt6.qt6cr_style_hint_return_type(handle)
      when StyleHintReturnType::Mask.value
        StyleHintReturnMask.wrap(handle, owned)
      when StyleHintReturnType::Variant.value
        StyleHintReturnVariant.wrap(handle, owned)
      else
        new(handle, owned)
      end
    end

    # Creates a base style-hint return payload with the given version and type.
    def initialize(version : Int = 1, type : StyleHintReturnType = StyleHintReturnType::Default)
      super(LibQt6.qt6cr_style_hint_return_create(version.to_i32, type.value))
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the raw style-hint return version.
    def version : Int32
      LibQt6.qt6cr_style_hint_return_version(to_unsafe)
    end

    # Sets the style-hint return version and returns it.
    def version=(value : Int) : Int32
      typed_value = value.to_i32
      LibQt6.qt6cr_style_hint_return_set_version(to_unsafe, typed_value)
      typed_value
    end

    # Returns the current Qt style-hint return type.
    def type : StyleHintReturnType
      StyleHintReturnType.from_value(LibQt6.qt6cr_style_hint_return_type(to_unsafe))
    end

    # Sets the style-hint return type and returns it.
    def type=(value : StyleHintReturnType) : StyleHintReturnType
      LibQt6.qt6cr_style_hint_return_set_type(to_unsafe, value.value)
      value
    end

    # Qt-style alias for `version=`.
    def set_version(value : Int) : self
      self.version = value
      self
    end

    # Qt-style alias for `type=`.
    def set_type(value : StyleHintReturnType) : self
      self.type = value
      self
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_style_hint_return_destroy(to_unsafe)
    end
  end
end
