module Qt6
  # Wraps `QByteArray` for binary payload interchange.
  class QByteArray < NativeResource
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize
      super(LibQt6.qt6cr_qbyte_array_create)
    end

    def initialize(data : Bytes)
      super(LibQt6.qt6cr_qbyte_array_create_from_data(data.to_unsafe, data.size))
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def size : Int32
      LibQt6.qt6cr_qbyte_array_size(to_unsafe)
    end

    def empty? : Bool
      size.zero?
    end

    def bytes : Bytes
      Qt6.copy_and_release_bytes(LibQt6.qt6cr_qbyte_array_data(to_unsafe))
    end

    def clear : self
      LibQt6.qt6cr_qbyte_array_clear(to_unsafe)
      self
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_qbyte_array_destroy(to_unsafe)
    end
  end
end
