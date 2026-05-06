module Qt6
  # Wraps `QCommonStyle`.
  class CommonStyle < Style
    # Creates a standalone common style instance.
    def initialize
      super(LibQt6.qt6cr_common_style_create, true)
    end
  end
end
