module Qt6
  # Wraps a `QStyle` instance.
  class Style < QObject
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the style's Qt name.
    def name : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_style_name(to_unsafe))
    end

    # Returns the style's standard palette.
    def standard_palette : QPalette
      QPalette.wrap(LibQt6.qt6cr_style_standard_palette(to_unsafe), true)
    end
  end
end
