module Qt6
  # Wraps `QPushButton`.
  class PushButton < AbstractButton
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a push button with optional text and parent.
    def initialize(text : String = "", parent : Widget? = nil)
      super(LibQt6.qt6cr_push_button_create(parent.try(&.to_unsafe) || Pointer(Void).null, text.to_unsafe), parent.nil?)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the menu shown when the button is pressed, if one is assigned.
    def menu : Menu?
      handle = LibQt6.qt6cr_push_button_menu(to_unsafe)
      handle.null? ? nil : Menu.wrap(handle)
    end

    # Sets the menu shown when the button is pressed.
    def menu=(value : Menu?) : Menu?
      LibQt6.qt6cr_push_button_set_menu(to_unsafe, value.try(&.to_unsafe) || Pointer(Void).null)
      value
    end
  end
end
