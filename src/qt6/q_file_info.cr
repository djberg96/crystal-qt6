module Qt6
  # Wraps `QFileInfo` for file metadata and path inspection.
  class QFileInfo < NativeResource
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates file info for a path.
    def initialize(path : String)
      super(LibQt6.qt6cr_qfile_info_create(path.to_unsafe))
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the trailing file or directory name.
    def file_name : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_qfile_info_file_name(to_unsafe))
    end

    # Returns the file name without its final suffix.
    def base_name : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_qfile_info_base_name(to_unsafe))
    end

    # Returns the final suffix without the leading dot.
    def suffix : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_qfile_info_suffix(to_unsafe))
    end

    # Returns the absolute file path.
    def absolute_file_path : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_qfile_info_absolute_file_path(to_unsafe))
    end

    # Returns the absolute directory path containing the file.
    def absolute_path : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_qfile_info_absolute_path(to_unsafe))
    end

    # Returns a directory wrapper for the containing directory.
    def directory : QDir
      QDir.new(absolute_path)
    end

    # Returns whether the path currently exists.
    def exists? : Bool
      LibQt6.qt6cr_qfile_info_exists(to_unsafe)
    end

    # Returns whether the path points to a regular file.
    def file? : Bool
      LibQt6.qt6cr_qfile_info_is_file(to_unsafe)
    end

    # Returns whether the path points to a directory.
    def dir? : Bool
      LibQt6.qt6cr_qfile_info_is_dir(to_unsafe)
    end

    # Returns the file size in bytes.
    def size : Int64
      LibQt6.qt6cr_qfile_info_size(to_unsafe)
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_qfile_info_destroy(to_unsafe)
    end
  end
end
