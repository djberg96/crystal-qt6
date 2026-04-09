module Qt6
  class FileDialog < Dialog
    def initialize(parent : Widget? = nil, directory : String = "", filter : String = "")
      super(LibQt6.qt6cr_file_dialog_create(parent.try(&.to_unsafe) || Pointer(Void).null, directory.to_unsafe, filter.to_unsafe), parent.nil?)
    end

    def accept_mode : FileDialogAcceptMode
      FileDialogAcceptMode.from_value(LibQt6.qt6cr_file_dialog_accept_mode(to_unsafe))
    end

    def accept_mode=(value : FileDialogAcceptMode) : FileDialogAcceptMode
      LibQt6.qt6cr_file_dialog_set_accept_mode(to_unsafe, value.value)
      value
    end

    def file_mode : FileDialogFileMode
      FileDialogFileMode.from_value(LibQt6.qt6cr_file_dialog_file_mode(to_unsafe))
    end

    def file_mode=(value : FileDialogFileMode) : FileDialogFileMode
      LibQt6.qt6cr_file_dialog_set_file_mode(to_unsafe, value.value)
      value
    end

    def directory : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_file_dialog_directory(to_unsafe))
    end

    def directory=(value : String) : String
      LibQt6.qt6cr_file_dialog_set_directory(to_unsafe, value.to_unsafe)
      value
    end

    def name_filter : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_file_dialog_name_filter(to_unsafe))
    end

    def name_filter=(value : String) : String
      LibQt6.qt6cr_file_dialog_set_name_filter(to_unsafe, value.to_unsafe)
      value
    end

    def select_file(path : String) : self
      LibQt6.qt6cr_file_dialog_select_file(to_unsafe, path.to_unsafe)
      self
    end

    def selected_file : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_file_dialog_selected_file(to_unsafe))
    end
  end
end
