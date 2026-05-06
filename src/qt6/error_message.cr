module Qt6
  # Wraps `QErrorMessage`.
  class ErrorMessage < Dialog
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Returns Qt's shared process-wide error-message handler dialog.
    def self.qt_handler : self
      wrap(LibQt6.qt6cr_error_message_qt_handler)
    end

    # Creates an error-message dialog with an optional parent.
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_error_message_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Shows a message immediately or queues it behind pending messages.
    def show_message(message : String) : self
      LibQt6.qt6cr_error_message_show_message(to_unsafe, message.to_unsafe)
      self
    end

    # Shows a typed message, allowing Qt to suppress repeated categories.
    def show_message(message : String, type : String) : self
      LibQt6.qt6cr_error_message_show_typed_message(to_unsafe, message.to_unsafe, type.to_unsafe)
      self
    end
  end
end
