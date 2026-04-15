module Qt6
  # Wraps `QDir` for path and directory utilities.
  class QDir < NativeResource
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a directory wrapper for the given path.
    def initialize(path : String = "")
      super(LibQt6.qt6cr_qdir_create(path.to_unsafe))
    end

    # Returns the process current working directory path.
    def self.current_path : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_qdir_current_path)
    end

    # Returns the current user's home directory path.
    def self.home_path : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_qdir_home_path)
    end

    # Normalizes a path string by collapsing redundant separators and traversals.
    def self.clean_path(path : String) : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_qdir_clean_path(path.to_unsafe))
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the wrapped directory path.
    def path : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_qdir_path(to_unsafe))
    end

    # Returns the absolute path for the directory.
    def absolute_path : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_qdir_absolute_path(to_unsafe))
    end

    # Returns whether the directory exists.
    def exists? : Bool
      LibQt6.qt6cr_qdir_exists(to_unsafe)
    end

    # Returns a path under this directory without forcing it absolute.
    def file_path(name : String) : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_qdir_file_path(to_unsafe, name.to_unsafe))
    end

    # Returns an absolute path under this directory.
    def absolute_file_path(name : String) : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_qdir_absolute_file_path(to_unsafe, name.to_unsafe))
    end

    # Ensures the relative or absolute subpath exists.
    def mkpath(path : String = ".") : Bool
      LibQt6.qt6cr_qdir_mkpath(to_unsafe, path.to_unsafe)
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_qdir_destroy(to_unsafe)
    end
  end
end
