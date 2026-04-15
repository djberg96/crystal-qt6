module Qt6
  # Wraps `QBuffer` for in-memory device-backed image serialization.
  class QBuffer < IODevice
    @byte_array : QByteArray?

    def initialize(byte_array : QByteArray? = nil)
      @byte_array = byte_array
      super(LibQt6.qt6cr_qbuffer_create(byte_array.try(&.to_unsafe) || Pointer(Void).null))
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      @byte_array = nil
      super(handle, owned)
    end

    def data : QByteArray
      QByteArray.wrap(LibQt6.qt6cr_qbuffer_data(to_unsafe), true)
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_qbuffer_destroy(to_unsafe)
    end
  end
end
