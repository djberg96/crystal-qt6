module Qt6
  # Wraps `QIcon` for application and window icon configuration.
  class QIcon < NativeResource
    # Creates an empty icon.
    def initialize
      super(LibQt6.qt6cr_qicon_create)
    end

    # Loads an icon from disk.
    def initialize(path : String)
      super(LibQt6.qt6cr_qicon_create_from_file(path.to_unsafe))
    end

    # Wraps an existing native icon handle.
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Loads an icon from disk.
    def self.from_file(path : String) : self
      new(path)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns `true` if the icon contains no usable pixmaps.
    def null? : Bool
      LibQt6.qt6cr_qicon_is_null(to_unsafe)
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_qicon_destroy(to_unsafe)
    end
  end
end
