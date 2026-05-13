module Qt6
  # Wraps `QRadioButton`.
  class RadioButton < AbstractButton
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a radio button with optional text and parent.
    def initialize(text : String = "", parent : Widget? = nil)
      super(LibQt6.qt6cr_radio_button_create(parent.try(&.to_unsafe) || Pointer(Void).null, text.to_unsafe), parent.nil?)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns `true` when sibling radio buttons are automatically exclusive.
    def auto_exclusive? : Bool
      LibQt6.qt6cr_radio_button_auto_exclusive(to_unsafe)
    end

    # Enables or disables automatic exclusivity with sibling radio buttons.
    def auto_exclusive=(value : Bool) : Bool
      LibQt6.qt6cr_radio_button_set_auto_exclusive(to_unsafe, value)
      value
    end

    # Returns the preferred size for the current radio button label and indicator.
    def size_hint : Size
      Size.from_native(LibQt6.qt6cr_radio_button_size_hint(to_unsafe))
    end

    # Returns the minimum recommended size for the radio button.
    def minimum_size_hint : Size
      Size.from_native(LibQt6.qt6cr_radio_button_minimum_size_hint(to_unsafe))
    end

    # Qt-style alias for `text=`.
    def set_text(value : String) : self
      self.text = value
      self
    end

    # Qt-style alias for `checked=`.
    def set_checked(value : Bool) : self
      self.checked = value
      self
    end

    # Qt-style alias for `auto_exclusive=`.
    def set_auto_exclusive(value : Bool) : self
      self.auto_exclusive = value
      self
    end
  end
end
