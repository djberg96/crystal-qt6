module Qt6
  # Wraps `QFileSystemModel` for live directory browsing in item views.
  class FileSystemModel < AbstractItemModel
    @root_path_changed : Signal(String) = Signal(String).new
    @directory_loaded : Signal(String) = Signal(String).new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    getter root_path_changed : Signal(String)
    getter directory_loaded : Signal(String)

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a file-system model with an optional QObject parent.
    def initialize(parent : QObject? = nil)
      super(LibQt6.qt6cr_file_system_model_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      register_callbacks
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      register_callbacks
    end

    # Returns a model index for the given path and column.
    def index(path : String, column : Int = 0) : ModelIndex
      ModelIndex.wrap(LibQt6.qt6cr_file_system_model_index_for_path(to_unsafe, path.to_unsafe, column.to_i32), true)
    end

    # Sorts the current directory entries.
    def sort(column : Int = 0, order : SortOrder = SortOrder::Ascending) : self
      LibQt6.qt6cr_file_system_model_sort(to_unsafe, column.to_i32, order.value)
      self
    end

    # Sets the watched root path and returns its model index.
    def set_root_path(path : String) : ModelIndex
      ModelIndex.wrap(LibQt6.qt6cr_file_system_model_set_root_path(to_unsafe, path.to_unsafe), true)
    end

    # Returns the current watched root path.
    def root_path : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_file_system_model_root_path(to_unsafe))
    end

    # Returns the current watched root directory.
    def root_directory : QDir
      QDir.wrap(LibQt6.qt6cr_file_system_model_root_directory(to_unsafe), true)
    end

    # Installs a concrete file icon provider.
    def icon_provider=(provider : FileIconProvider) : FileIconProvider
      LibQt6.qt6cr_file_system_model_set_icon_provider(to_unsafe, provider.to_unsafe)
      provider.adopt_by_owner!
      provider
    end

    # Returns the current icon provider when it is a `QFileIconProvider`.
    def icon_provider : FileIconProvider?
      handle = LibQt6.qt6cr_file_system_model_icon_provider(to_unsafe)
      handle.null? ? nil : FileIconProvider.wrap(handle)
    end

    # Sets the directory-entry filters and returns them.
    def filter=(value : DirectoryFilter) : DirectoryFilter
      LibQt6.qt6cr_file_system_model_set_filter(to_unsafe, value.value)
      value
    end

    # Returns the active directory-entry filters.
    def filter : DirectoryFilter
      DirectoryFilter.from_value(LibQt6.qt6cr_file_system_model_filter(to_unsafe))
    end

    # Enables or disables symlink resolution.
    def resolve_symlinks=(value : Bool) : Bool
      LibQt6.qt6cr_file_system_model_set_resolve_symlinks(to_unsafe, value)
      value
    end

    # Returns `true` when symlinks are resolved.
    def resolve_symlinks? : Bool
      LibQt6.qt6cr_file_system_model_resolve_symlinks(to_unsafe)
    end

    # Enables or disables write operations.
    def read_only=(value : Bool) : Bool
      LibQt6.qt6cr_file_system_model_set_read_only(to_unsafe, value)
      value
    end

    # Returns `true` when the model is read-only.
    def read_only? : Bool
      LibQt6.qt6cr_file_system_model_is_read_only(to_unsafe)
    end

    # Enables or disables name-filter dimming instead of hiding.
    def name_filter_disables=(value : Bool) : Bool
      LibQt6.qt6cr_file_system_model_set_name_filter_disables(to_unsafe, value)
      value
    end

    # Returns `true` when filtered-out entries stay visible but disabled.
    def name_filter_disables? : Bool
      LibQt6.qt6cr_file_system_model_name_filter_disables(to_unsafe)
    end

    # Replaces the wildcard name filters and returns them.
    def name_filters=(filters : Enumerable(String)) : Array(String)
      values = filters.to_a
      pointers = values.map(&.to_unsafe)
      LibQt6.qt6cr_file_system_model_set_name_filters(
        to_unsafe,
        pointers.empty? ? Pointer(UInt8*).null : pointers.to_unsafe,
        pointers.size
      )
      values
    end

    # Returns the wildcard name filters.
    def name_filters : Array(String)
      Qt6.copy_and_release_strings(LibQt6.qt6cr_file_system_model_name_filters(to_unsafe))
    end

    # Enables or disables a single file-system-model option.
    def set_option(option : FileSystemModelOption, value : Bool = true) : Bool
      LibQt6.qt6cr_file_system_model_set_option(to_unsafe, option.value, value)
      value
    end

    # Returns `true` when the option is enabled.
    def option?(option : FileSystemModelOption) : Bool
      LibQt6.qt6cr_file_system_model_test_option(to_unsafe, option.value)
    end

    # Returns the absolute file path for an index.
    def file_path(index : ModelIndex) : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_file_system_model_file_path(to_unsafe, index.to_unsafe))
    end

    # Returns the leaf file name for an index.
    def file_name(index : ModelIndex) : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_file_system_model_file_name(to_unsafe, index.to_unsafe))
    end

    # Returns `true` when the index points to a directory.
    def dir?(index : ModelIndex) : Bool
      LibQt6.qt6cr_file_system_model_is_dir(to_unsafe, index.to_unsafe)
    end

    # Returns the byte size for the indexed entry.
    def size(index : ModelIndex) : Int64
      LibQt6.qt6cr_file_system_model_size(to_unsafe, index.to_unsafe)
    end

    # Returns Qt's localized type description for the indexed entry.
    def type(index : ModelIndex) : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_file_system_model_type(to_unsafe, index.to_unsafe))
    end

    # Returns file metadata for the indexed entry.
    def file_info(index : ModelIndex) : QFileInfo
      QFileInfo.wrap(LibQt6.qt6cr_file_system_model_file_info(to_unsafe, index.to_unsafe), true)
    end

    # Creates a directory under the given parent and returns its index.
    def mkdir(parent : ModelIndex, name : String) : ModelIndex
      ModelIndex.wrap(LibQt6.qt6cr_file_system_model_mkdir(to_unsafe, parent.to_unsafe, name.to_unsafe), true)
    end

    # Removes the indexed directory.
    def rmdir(index : ModelIndex) : Bool
      LibQt6.qt6cr_file_system_model_rmdir(to_unsafe, index.to_unsafe)
    end

    # Removes the indexed file.
    def remove(index : ModelIndex) : Bool
      LibQt6.qt6cr_file_system_model_remove(to_unsafe, index.to_unsafe)
    end

    # Registers a block to run when the root path changes.
    def on_root_path_changed(&block : String ->) : self
      @root_path_changed.connect { |value| block.call(value) }
      self
    end

    # Registers a block to run when a directory finishes loading.
    def on_directory_loaded(&block : String ->) : self
      @directory_loaded.connect { |value| block.call(value) }
      self
    end

    protected def emit_root_path_changed(value : String) : Nil
      @root_path_changed.emit(value)
    end

    protected def emit_directory_loaded(value : String) : Nil
      @directory_loaded.emit(value)
    end

    private def register_callbacks : Nil
      @root_path_changed = Signal(String).new
      @directory_loaded = Signal(String).new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_file_system_model_on_root_path_changed(to_unsafe, ROOT_PATH_CHANGED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_file_system_model_on_directory_loaded(to_unsafe, DIRECTORY_LOADED_TRAMPOLINE, @callback_userdata)
    end

    private ROOT_PATH_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : UInt8*) do
      Box(FileSystemModel).unbox(userdata).emit_root_path_changed(Qt6.copy_string(value))
    end

    private DIRECTORY_LOADED_TRAMPOLINE = ->(userdata : Void*, value : UInt8*) do
      Box(FileSystemModel).unbox(userdata).emit_directory_loaded(Qt6.copy_string(value))
    end
  end
end
