module Qt6
  # Wraps `QFile` for file-backed I/O using Qt's device API.
  class QFile < NativeResource
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

    # Opens the file with the given Qt device mode flags.
    def open(mode : IODeviceOpenMode) : Bool
      LibQt6.qt6cr_qfile_open(to_unsafe, mode.value)
    end

    # Closes the file handle.
    def close : self
      LibQt6.qt6cr_qfile_close(to_unsafe)
      self
    end

    # Returns whether the file is currently open.
    def open? : Bool
      LibQt6.qt6cr_qfile_is_open(to_unsafe)
    end

    # Returns the current file size in bytes.
    def size : Int64
      LibQt6.qt6cr_qfile_size(to_unsafe)
    end

    # Reads the entire file contents from the current position.
    def read_all : QByteArray
      QByteArray.new(Qt6.copy_and_release_bytes(LibQt6.qt6cr_qfile_read_all(to_unsafe)))
    end

    # Writes bytes to the file and returns the number of bytes accepted.
    def write(data : Bytes) : Int64
      LibQt6.qt6cr_qfile_write(to_unsafe, data.to_unsafe, data.size)
    end

    # Writes UTF-8 text to the file and returns the number of bytes accepted.
    def write(data : String) : Int64
      slice = data.to_slice
      write(slice)
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
