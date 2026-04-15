module Qt6
  # Shared wrapper for `QIODevice`-style byte streams.
  abstract class IODevice < NativeResource
    protected def initialize(handle : LibQt6::Handle, owned : Bool = true)
      super(handle, owned)
    end

    # Opens the device with the given Qt device mode flags.
    def open(mode : IODeviceOpenMode) : Bool
      LibQt6.qt6cr_io_device_open(to_unsafe, mode.value)
    end

    # Closes the device handle.
    def close : self
      LibQt6.qt6cr_io_device_close(to_unsafe)
      self
    end

    # Returns whether the device is currently open.
    def open? : Bool
      LibQt6.qt6cr_io_device_is_open(to_unsafe)
    end

    # Returns the current device size in bytes.
    def size : Int64
      LibQt6.qt6cr_io_device_size(to_unsafe)
    end

    # Returns the current read/write position.
    def position : Int64
      LibQt6.qt6cr_io_device_position(to_unsafe)
    end

    # Seeks to an absolute device position.
    def seek(position : Int) : Bool
      LibQt6.qt6cr_io_device_seek(to_unsafe, position.to_i64)
    end

    # Returns whether the device has reached its end.
    def at_end? : Bool
      LibQt6.qt6cr_io_device_at_end(to_unsafe)
    end

    # Returns the number of bytes immediately available for reading.
    def bytes_available : Int64
      LibQt6.qt6cr_io_device_bytes_available(to_unsafe)
    end

    # Reads up to `size` bytes from the current position.
    def read(size : Int) : QByteArray
      QByteArray.new(Qt6.copy_and_release_bytes(LibQt6.qt6cr_io_device_read(to_unsafe, size.to_i32)))
    end

    # Peeks up to `size` bytes without advancing the current position.
    def peek(size : Int) : QByteArray
      QByteArray.new(Qt6.copy_and_release_bytes(LibQt6.qt6cr_io_device_peek(to_unsafe, size.to_i32)))
    end

    # Reads all remaining bytes from the current position.
    def read_all : QByteArray
      QByteArray.new(Qt6.copy_and_release_bytes(LibQt6.qt6cr_io_device_read_all(to_unsafe)))
    end

    # Writes bytes to the device and returns the number of bytes accepted.
    def write(data : Bytes) : Int64
      LibQt6.qt6cr_io_device_write(to_unsafe, data.to_unsafe, data.size)
    end

    # Writes UTF-8 text to the device and returns the number of bytes accepted.
    def write(data : String) : Int64
      write(data.to_slice)
    end
  end
end
