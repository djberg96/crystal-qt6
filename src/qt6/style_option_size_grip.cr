module Qt6
  # Wraps `QStyleOptionSizeGrip` for size-grip paint state.
  class StyleOptionSizeGrip < StyleOptionComplex
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize
      super(LibQt6.qt6cr_style_option_size_grip_create, true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def corner : Corner
      Corner.from_value(LibQt6.qt6cr_style_option_size_grip_corner(to_unsafe))
    end

    def corner=(value : Corner) : Corner
      LibQt6.qt6cr_style_option_size_grip_set_corner(to_unsafe, value.value)
      value
    end

    def set_corner(value : Corner) : self
      self.corner = value
      self
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_style_option_size_grip_destroy(to_unsafe)
    end
  end
end
