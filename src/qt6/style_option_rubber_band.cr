module Qt6
  # Wraps `QStyleOptionRubberBand` for rubber-band paint state.
  class StyleOptionRubberBand < StyleOption
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize
      super(LibQt6.qt6cr_style_option_rubber_band_create, true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def shape : RubberBandShape
      RubberBandShape.from_value(LibQt6.qt6cr_style_option_rubber_band_shape(to_unsafe))
    end

    def shape=(value : RubberBandShape) : RubberBandShape
      LibQt6.qt6cr_style_option_rubber_band_set_shape(to_unsafe, value.value)
      value
    end

    def opaque? : Bool
      LibQt6.qt6cr_style_option_rubber_band_opaque(to_unsafe)
    end

    def opaque=(value : Bool) : Bool
      LibQt6.qt6cr_style_option_rubber_band_set_opaque(to_unsafe, value)
      value
    end

    def init_from(rubber_band : RubberBand) : self
      LibQt6.qt6cr_style_option_init_from(to_unsafe, rubber_band.to_unsafe)
      LibQt6.qt6cr_rubber_band_init_style_option(rubber_band.to_unsafe, to_unsafe)
      self
    end

    def set_shape(value : RubberBandShape) : self
      self.shape = value
      self
    end

    def set_opaque(value : Bool) : self
      self.opaque = value
      self
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_style_option_rubber_band_destroy(to_unsafe)
    end
  end
end
