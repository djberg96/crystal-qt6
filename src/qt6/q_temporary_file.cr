module Qt6
  # Wraps `QTemporaryFile` for scoped scratch files.
  class QTemporaryFile < QFile
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def self.create_native_file(file_name : String) : self?
      handle = LibQt6.qt6cr_qtemporary_file_create_native_file(file_name.to_unsafe)
      handle.null? ? nil : new(handle, true)
    end

    def initialize(template_name : String? = nil)
      super(LibQt6.qt6cr_qtemporary_file_create(template_name.try(&.to_unsafe) || Pointer(UInt8).null), true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def auto_remove? : Bool
      LibQt6.qt6cr_qtemporary_file_auto_remove(to_unsafe)
    end

    def auto_remove=(value : Bool) : Bool
      LibQt6.qt6cr_qtemporary_file_set_auto_remove(to_unsafe, value)
      value
    end

    def open : Bool
      LibQt6.qt6cr_qtemporary_file_open(to_unsafe)
    end

    def file_template : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_qtemporary_file_file_template(to_unsafe))
    end

    def file_template=(value : String) : String
      LibQt6.qt6cr_qtemporary_file_set_file_template(to_unsafe, value.to_unsafe)
      value
    end

    def rename(new_name : String) : Bool
      LibQt6.qt6cr_qtemporary_file_rename(to_unsafe, new_name.to_unsafe)
    end

    def rename_overwrite(new_name : String) : Bool
      LibQt6.qt6cr_qtemporary_file_rename_overwrite(to_unsafe, new_name.to_unsafe)
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_qtemporary_file_destroy(to_unsafe)
    end
  end
end
