module Qt6
  # Wraps `QLockFile` for advisory single-writer file locks.
  class QLockFile < NativeResource
    def initialize(file_name : String)
      super(LibQt6.qt6cr_qlock_file_create(file_name.to_unsafe))
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def file_name : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_qlock_file_file_name(to_unsafe))
    end

    def lock : Bool
      LibQt6.qt6cr_qlock_file_lock(to_unsafe)
    end

    def try_lock(timeout_ms : Int = 0) : Bool
      LibQt6.qt6cr_qlock_file_try_lock(to_unsafe, timeout_ms.to_i32)
    end

    def unlock : self
      LibQt6.qt6cr_qlock_file_unlock(to_unsafe)
      self
    end

    def locked? : Bool
      LibQt6.qt6cr_qlock_file_is_locked(to_unsafe)
    end

    def stale_lock_time : Int32
      LibQt6.qt6cr_qlock_file_stale_lock_time(to_unsafe)
    end

    def stale_lock_time=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_qlock_file_set_stale_lock_time(to_unsafe, int_value)
      int_value
    end

    def lock_info : LockFileInfo?
      LockFileInfo.from_native(LibQt6.qt6cr_qlock_file_lock_info(to_unsafe))
    end

    def remove_stale_lock_file : Bool
      LibQt6.qt6cr_qlock_file_remove_stale_lock_file(to_unsafe)
    end

    def error : LockFileError
      LockFileError.from_value(LibQt6.qt6cr_qlock_file_error(to_unsafe))
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_qlock_file_destroy(to_unsafe)
    end
  end
end
