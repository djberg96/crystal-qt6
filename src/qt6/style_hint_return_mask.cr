module Qt6
  # Wraps `QStyleHintReturnMask` for style-hint region payloads.
  class StyleHintReturnMask < StyleHintReturn
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a mask style-hint return payload.
    def initialize
      super(LibQt6.qt6cr_style_hint_return_mask_create, true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the current mask region.
    def region : QRegion
      QRegion.wrap(LibQt6.qt6cr_style_hint_return_mask_region(to_unsafe), true)
    end

    # Sets the mask region and returns it.
    def region=(value : QRegion) : QRegion
      LibQt6.qt6cr_style_hint_return_mask_set_region(to_unsafe, value.to_unsafe)
      value
    end

    # Qt-style alias for `region=`.
    def set_region(value : QRegion) : self
      self.region = value
      self
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_style_hint_return_mask_destroy(to_unsafe)
    end
  end
end
