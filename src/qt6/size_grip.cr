module Qt6
  # Wraps `QSizeGrip`.
  class SizeGrip < Widget
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a size grip with an optional parent.
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_size_grip_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the grip's preferred size.
    def size_hint : Size
      Size.from_native(LibQt6.qt6cr_size_grip_size_hint(to_unsafe))
    end

    # Qt-style alias for `visible=`.
    def set_visible(value : Bool) : self
      self.visible = value
      self
    end
  end
end
