module Qt6
  # Wraps `QFileDialog`.
  class FileDialog < Dialog
    # Opens a modal file picker and returns the chosen path, if any.
    def self.get_open_file_name(parent : Widget? = nil, title : String = "", directory : String = "", filter : String = "") : String?
      pointer = LibQt6.qt6cr_file_dialog_get_open_file_name(parent.try(&.to_unsafe) || Pointer(Void).null, title.to_unsafe, directory.to_unsafe, filter.to_unsafe)
      pointer.null? ? nil : Qt6.copy_and_release_string(pointer)
    end

    # Opens a modal file picker and returns the chosen paths.
    def self.get_open_file_names(parent : Widget? = nil, title : String = "", directory : String = "", filter : String = "") : Array(String)
      Qt6.copy_and_release_strings(LibQt6.qt6cr_file_dialog_get_open_file_names(parent.try(&.to_unsafe) || Pointer(Void).null, title.to_unsafe, directory.to_unsafe, filter.to_unsafe))
    end

    # Opens a modal save dialog and returns the chosen path, if any.
    def self.get_save_file_name(parent : Widget? = nil, title : String = "", directory : String = "", filter : String = "") : String?
      pointer = LibQt6.qt6cr_file_dialog_get_save_file_name(parent.try(&.to_unsafe) || Pointer(Void).null, title.to_unsafe, directory.to_unsafe, filter.to_unsafe)
      pointer.null? ? nil : Qt6.copy_and_release_string(pointer)
    end

    # Opens a modal directory picker and returns the chosen path, if any.
    def self.get_existing_directory(parent : Widget? = nil, title : String = "", directory : String = "", options : FileDialogOption = FileDialogOption::ShowDirsOnly) : String?
      pointer = LibQt6.qt6cr_file_dialog_get_existing_directory(parent.try(&.to_unsafe) || Pointer(Void).null, title.to_unsafe, directory.to_unsafe, options.value)
      pointer.null? ? nil : Qt6.copy_and_release_string(pointer)
    end

    # Creates a file dialog with optional starting directory and name filter.
    def initialize(parent : Widget? = nil, directory : String = "", filter : String = "")
      super(LibQt6.qt6cr_file_dialog_create(parent.try(&.to_unsafe) || Pointer(Void).null, directory.to_unsafe, filter.to_unsafe), parent.nil?)
    end

    # Returns the current accept mode.
    def accept_mode : FileDialogAcceptMode
      FileDialogAcceptMode.from_value(LibQt6.qt6cr_file_dialog_accept_mode(to_unsafe))
    end

    # Sets the accept mode and returns it.
    def accept_mode=(value : FileDialogAcceptMode) : FileDialogAcceptMode
      LibQt6.qt6cr_file_dialog_set_accept_mode(to_unsafe, value.value)
      value
    end

    # Returns the current file mode.
    def file_mode : FileDialogFileMode
      FileDialogFileMode.from_value(LibQt6.qt6cr_file_dialog_file_mode(to_unsafe))
    end

    # Sets the file mode and returns it.
    def file_mode=(value : FileDialogFileMode) : FileDialogFileMode
      LibQt6.qt6cr_file_dialog_set_file_mode(to_unsafe, value.value)
      value
    end

    # Returns the current item presentation mode.
    def view_mode : FileDialogViewMode
      FileDialogViewMode.from_value(LibQt6.qt6cr_file_dialog_view_mode(to_unsafe))
    end

    # Sets the item presentation mode and returns it.
    def view_mode=(value : FileDialogViewMode) : FileDialogViewMode
      LibQt6.qt6cr_file_dialog_set_view_mode(to_unsafe, value.value)
      value
    end

    # Returns the active file-dialog option flags.
    def options : FileDialogOption
      FileDialogOption.from_value(LibQt6.qt6cr_file_dialog_options(to_unsafe))
    end

    # Replaces the file-dialog option flags and returns them.
    def options=(value : FileDialogOption) : FileDialogOption
      LibQt6.qt6cr_file_dialog_set_options(to_unsafe, value.value)
      value
    end

    # Enables or disables a single file-dialog option.
    def set_option(option : FileDialogOption, value : Bool = true) : Bool
      LibQt6.qt6cr_file_dialog_set_option(to_unsafe, option.value, value)
      value
    end

    # Returns `true` when the given option is enabled.
    def option?(option : FileDialogOption) : Bool
      LibQt6.qt6cr_file_dialog_test_option(to_unsafe, option.value)
    end

    # Returns the active directory-entry filters.
    def filter : DirectoryFilter
      DirectoryFilter.from_value(LibQt6.qt6cr_file_dialog_filter(to_unsafe))
    end

    # Sets the active directory-entry filters.
    def filter=(value : DirectoryFilter) : DirectoryFilter
      LibQt6.qt6cr_file_dialog_set_filter(to_unsafe, value.value)
      value
    end

    # Returns the current directory path.
    def directory : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_file_dialog_directory(to_unsafe))
    end

    # Sets the current directory path.
    def directory=(value : String) : String
      LibQt6.qt6cr_file_dialog_set_directory(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the current name filter string.
    def name_filter : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_file_dialog_name_filter(to_unsafe))
    end

    # Sets the name filter string.
    def name_filter=(value : String) : String
      LibQt6.qt6cr_file_dialog_set_name_filter(to_unsafe, value.to_unsafe)
      value
    end

    # Replaces the available wildcard name filters and returns them.
    def name_filters=(filters : Enumerable(String)) : Array(String)
      values = filters.to_a
      pointers = values.map(&.to_unsafe)
      LibQt6.qt6cr_file_dialog_set_name_filters(
        to_unsafe,
        pointers.empty? ? Pointer(UInt8*).null : pointers.to_unsafe,
        pointers.size
      )
      values
    end

    # Returns the available wildcard name filters.
    def name_filters : Array(String)
      Qt6.copy_and_release_strings(LibQt6.qt6cr_file_dialog_name_filters(to_unsafe))
    end

    # Selects one of the available wildcard name filters.
    def select_name_filter(value : String) : self
      LibQt6.qt6cr_file_dialog_select_name_filter(to_unsafe, value.to_unsafe)
      self
    end

    # Returns the currently selected wildcard name filter.
    def selected_name_filter : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_file_dialog_selected_name_filter(to_unsafe))
    end

    # Returns the default suffix applied for new files.
    def default_suffix : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_file_dialog_default_suffix(to_unsafe))
    end

    # Sets the default suffix applied for new files.
    def default_suffix=(value : String) : String
      LibQt6.qt6cr_file_dialog_set_default_suffix(to_unsafe, value.to_unsafe)
      value
    end

    # Replaces the dialog's navigation history and returns it.
    def history=(paths : Enumerable(String)) : Array(String)
      values = paths.to_a
      pointers = values.map(&.to_unsafe)
      LibQt6.qt6cr_file_dialog_set_history(
        to_unsafe,
        pointers.empty? ? Pointer(UInt8*).null : pointers.to_unsafe,
        pointers.size
      )
      values
    end

    # Returns the dialog's navigation history.
    def history : Array(String)
      Qt6.copy_and_release_strings(LibQt6.qt6cr_file_dialog_history(to_unsafe))
    end

    # Returns the current text for a built-in dialog label.
    def label_text(label : FileDialogLabel) : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_file_dialog_label_text(to_unsafe, label.value))
    end

    # Replaces the text for a built-in dialog label.
    def set_label_text(label : FileDialogLabel, value : String) : self
      LibQt6.qt6cr_file_dialog_set_label_text(to_unsafe, label.value, value.to_unsafe)
      self
    end

    # Replaces the supported URL schemes and returns them.
    def supported_schemes=(schemes : Enumerable(String)) : Array(String)
      values = schemes.to_a
      pointers = values.map(&.to_unsafe)
      LibQt6.qt6cr_file_dialog_set_supported_schemes(
        to_unsafe,
        pointers.empty? ? Pointer(UInt8*).null : pointers.to_unsafe,
        pointers.size
      )
      values
    end

    # Returns the supported URL schemes.
    def supported_schemes : Array(String)
      Qt6.copy_and_release_strings(LibQt6.qt6cr_file_dialog_supported_schemes(to_unsafe))
    end

    # Preselects a file path in the dialog.
    def select_file(path : String) : self
      LibQt6.qt6cr_file_dialog_select_file(to_unsafe, path.to_unsafe)
      self
    end

    # Returns the first selected file path, if any.
    def selected_file : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_file_dialog_selected_file(to_unsafe))
    end

    # Returns all selected file paths.
    def selected_files : Array(String)
      Qt6.copy_and_release_strings(LibQt6.qt6cr_file_dialog_selected_files(to_unsafe))
    end
  end
end
