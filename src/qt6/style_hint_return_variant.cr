module Qt6
  # Wraps `QStyleHintReturnVariant` for style-hint variant payloads.
  class StyleHintReturnVariant < StyleHintReturn
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a variant style-hint return payload.
    def initialize
      super(LibQt6.qt6cr_style_hint_return_variant_create, true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the current variant payload using the shared model-data conversion layer.
    def variant : ModelData
      Qt6.model_data_from_native(LibQt6.qt6cr_style_hint_return_variant_variant(to_unsafe))
    end

    # Sets the variant payload using the shared model-data conversion layer.
    def variant=(value) : ModelData
      normalized = Qt6.normalize_model_data(value)
      LibQt6.qt6cr_style_hint_return_variant_set_variant(to_unsafe, Qt6.model_data_to_native(normalized))
      normalized
    end

    # Qt-style alias for `variant=`.
    def set_variant(value) : self
      self.variant = value
      self
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_style_hint_return_variant_destroy(to_unsafe)
    end
  end
end
