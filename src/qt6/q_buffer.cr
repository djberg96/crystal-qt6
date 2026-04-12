module Qt6
  # Wraps `QBuffer` for in-memory device-backed image serialization.
  class QBuffer < NativeResource
    @byte_array : QByteArray?

    def initialize(byte_array : QByteArray? = nil)
      @byte_array = byte_array
      super(LibQt6.qt6cr_qbuffer_create(byte_array.try(&.to_unsafe) || Pointer(Void).null))
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      @byte_array = nil
      super(handle, owned)
    end

    def open(mode : IODeviceOpenMode) : Bool
      LibQt6.qt6cr_qbuffer_open(to_unsafe, mode.value)
    end

    def close : self
      LibQt6.qt6cr_qbuffer_close(to_unsafe)
      self
    end

    def open? : Bool
      LibQt6.qt6cr_qbuffer_is_open(to_unsafe)
    end

    def data : QByteArray
      QByteArray.wrap(LibQt6.qt6cr_qbuffer_data(to_unsafe), true)
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_qbuffer_destroy(to_unsafe)
    end
  end
end
