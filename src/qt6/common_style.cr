module Qt6
  # Wraps `QCommonStyle`.
  class CommonStyle < Style
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a standalone common style instance.
    def initialize
      super(LibQt6.qt6cr_common_style_create, true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end
  end
end
