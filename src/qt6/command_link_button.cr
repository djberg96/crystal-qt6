module Qt6
  # Wraps `QCommandLinkButton`.
  class CommandLinkButton < PushButton
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(text : String = "", description : String = "", parent : Widget? = nil)
      super(LibQt6.qt6cr_command_link_button_create(parent.try(&.to_unsafe) || Pointer(Void).null, text.to_unsafe, description.to_unsafe), parent.nil?)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def description : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_command_link_button_description(to_unsafe))
    end

    def description=(value : String) : String
      LibQt6.qt6cr_command_link_button_set_description(to_unsafe, value.to_unsafe)
      value
    end
  end
end
