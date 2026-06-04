module Qt6
  # Wraps `QTemporaryDir` for scoped scratch directories.
  class QTemporaryDir < NativeResource
    @path_cache : String?
    @removed = false

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(template_name : String? = nil)
      @path_cache = nil
      super(LibQt6.qt6cr_qtemporary_dir_create(template_name.try(&.to_unsafe) || Pointer(UInt8).null))
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      @path_cache = nil
      super(handle, owned)
    end

    def valid? : Bool
      LibQt6.qt6cr_qtemporary_dir_is_valid(to_unsafe)
    end

    def error_string : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_qtemporary_dir_error_string(to_unsafe))
    end

    def auto_remove? : Bool
      LibQt6.qt6cr_qtemporary_dir_auto_remove(to_unsafe)
    end

    def auto_remove=(value : Bool) : Bool
      LibQt6.qt6cr_qtemporary_dir_set_auto_remove(to_unsafe, value)
      value
    end

    def remove : Bool
      current_path = path
      removed = LibQt6.qt6cr_qtemporary_dir_remove(to_unsafe)
      if removed
        @path_cache = current_path
        @removed = true
      end
      removed
    end

    def path : String
      cached = @path_cache
      return cached if @removed && cached

      Qt6.copy_and_release_string(LibQt6.qt6cr_qtemporary_dir_path(to_unsafe))
    end

    def file_path(file_name : String) : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_qtemporary_dir_file_path(to_unsafe, file_name.to_unsafe))
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_qtemporary_dir_destroy(to_unsafe)
    end
  end
end
