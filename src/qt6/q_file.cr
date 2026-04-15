module Qt6
  # Wraps `QFile` for file-backed I/O using Qt's device API.
  class QFile < IODevice
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Returns whether a path currently exists.
    def self.exists?(file_name : String) : Bool
      LibQt6.qt6cr_qfile_exists_at_path(file_name.to_unsafe)
    end

    # Creates a file wrapper for the given path.
    def initialize(file_name : String = "")
      super(LibQt6.qt6cr_qfile_create(file_name.to_unsafe))
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the current file name.
    def file_name : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_qfile_file_name(to_unsafe))
    end

    # Assigns the current file name and returns it.
    def file_name=(value : String) : String
      LibQt6.qt6cr_qfile_set_file_name(to_unsafe, value.to_unsafe)
      value
    end

    # Returns whether the file exists on disk.
    def exists? : Bool
      LibQt6.qt6cr_qfile_exists(to_unsafe)
    end

    # Flushes buffered file contents to the device.
    def flush : Bool
      LibQt6.qt6cr_qfile_flush(to_unsafe)
    end

    # Removes the file from disk.
    def remove : Bool
      LibQt6.qt6cr_qfile_remove(to_unsafe)
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_qfile_destroy(to_unsafe)
    end
  end
end
