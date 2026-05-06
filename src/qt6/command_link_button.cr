module Qt6
  # Wraps `QCommandLinkButton`.
  class CommandLinkButton < PushButton
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates an empty command-link button with an optional parent.
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_command_link_button_create(parent.try(&.to_unsafe) || Pointer(Void).null, "".to_unsafe, "".to_unsafe), parent.nil?)
    end

    # Creates a command-link button with primary text and an optional parent.
    def initialize(text : String, parent : Widget? = nil)
      super(LibQt6.qt6cr_command_link_button_create(parent.try(&.to_unsafe) || Pointer(Void).null, text.to_unsafe, "".to_unsafe), parent.nil?)
    end

    # Creates a command-link button with primary text, description, and an optional parent.
    def initialize(text : String, description : String, parent : Widget? = nil)
      super(LibQt6.qt6cr_command_link_button_create(parent.try(&.to_unsafe) || Pointer(Void).null, text.to_unsafe, description.to_unsafe), parent.nil?)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the secondary descriptive text.
    def description : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_command_link_button_description(to_unsafe))
    end

    # Sets the secondary descriptive text and returns the assigned value.
    def description=(value : String) : String
      LibQt6.qt6cr_command_link_button_set_description(to_unsafe, value.to_unsafe)
      value
    end

    # Qt-style alias for assigning the description.
    def set_description(value : String) : self
      self.description = value
      self
    end
  end
end
