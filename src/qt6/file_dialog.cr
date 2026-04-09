module Qt6
  # Wraps `QFileDialog`.
  class FileDialog < Dialog
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

    # Preselects a file path in the dialog.
    def select_file(path : String) : self
      LibQt6.qt6cr_file_dialog_select_file(to_unsafe, path.to_unsafe)
      self
    end

    # Returns the first selected file path, if any.
    def selected_file : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_file_dialog_selected_file(to_unsafe))
    end
  end
end
