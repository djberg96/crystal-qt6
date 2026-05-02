module Qt6
  # Wraps `QFileIconProvider` for filesystem-themed icon lookup.
  class FileIconProvider < NativeResource
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a file icon provider.
    def initialize
      super(LibQt6.qt6cr_file_icon_provider_create)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns a themed icon for one of Qt's stock file-system roles.
    def icon(type : FileIconType) : QIcon
      QIcon.wrap(LibQt6.qt6cr_file_icon_provider_icon_for_type(to_unsafe, type.value), true)
    end

    # Returns an icon for the given file info.
    def icon(file_info : QFileInfo) : QIcon
      QIcon.wrap(LibQt6.qt6cr_file_icon_provider_icon_for_file_info(to_unsafe, file_info.to_unsafe), true)
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_file_icon_provider_destroy(to_unsafe)
    end
  end
end
