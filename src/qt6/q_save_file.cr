module Qt6
  # Wraps `QSaveFile` for safe replacement writes.
  class QSaveFile < IODevice
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(file_name : String = "")
      super(LibQt6.qt6cr_qsave_file_create(file_name.to_unsafe))
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def file_name : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_qsave_file_file_name(to_unsafe))
    end

    def file_name=(value : String) : String
      LibQt6.qt6cr_qsave_file_set_file_name(to_unsafe, value.to_unsafe)
      value
    end

    def open(mode : IODeviceOpenMode = IODeviceOpenMode::WriteOnly) : Bool
      LibQt6.qt6cr_qsave_file_open(to_unsafe, mode.value)
    end

    def commit : Bool
      LibQt6.qt6cr_qsave_file_commit(to_unsafe)
    end

    def cancel_writing : self
      LibQt6.qt6cr_qsave_file_cancel_writing(to_unsafe)
      self
    end

    def direct_write_fallback? : Bool
      LibQt6.qt6cr_qsave_file_direct_write_fallback(to_unsafe)
    end

    def direct_write_fallback=(value : Bool) : Bool
      LibQt6.qt6cr_qsave_file_set_direct_write_fallback(to_unsafe, value)
      value
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_qsave_file_destroy(to_unsafe)
    end
  end
end
