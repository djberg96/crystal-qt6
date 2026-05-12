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

    # Creates a push button with an icon, text, and optional parent.
    def initialize(icon : QIcon, text : String = "", parent : Widget? = nil)
      super(
        LibQt6.qt6cr_push_button_create_with_icon(
          parent.try(&.to_unsafe) || Pointer(Void).null,
          icon.to_unsafe,
          text.to_unsafe
        ),
        parent.nil?
      )
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
      value.adopt_by_parent! unless value.nil?
      value
    end

    # Returns `true` when the button is the dialog's default button.
    def default? : Bool
      LibQt6.qt6cr_push_button_is_default(to_unsafe)
    end

    # Sets whether the button is the dialog's default button.
    def default=(value : Bool) : Bool
      LibQt6.qt6cr_push_button_set_default(to_unsafe, value)
      value
    end

    # Returns `true` when the button automatically becomes the default on focus.
    def auto_default? : Bool
      LibQt6.qt6cr_push_button_auto_default(to_unsafe)
    end

    # Enables or disables automatic default-button behavior.
    def auto_default=(value : Bool) : Bool
      LibQt6.qt6cr_push_button_set_auto_default(to_unsafe, value)
      value
    end

    # Returns `true` when the button draws with flat styling.
    def flat? : Bool
      LibQt6.qt6cr_push_button_is_flat(to_unsafe)
    end

    # Enables or disables flat button styling.
    def flat=(value : Bool) : Bool
      LibQt6.qt6cr_push_button_set_flat(to_unsafe, value)
      value
    end

    # Returns the preferred size for the button's current text, icon, and menu state.
    def size_hint : Size
      Size.from_native(LibQt6.qt6cr_push_button_size_hint(to_unsafe))
    end

    # Returns the minimum recommended size for the button.
    def minimum_size_hint : Size
      Size.from_native(LibQt6.qt6cr_push_button_minimum_size_hint(to_unsafe))
    end

    # Shows the attached menu, if one is assigned.
    def show_menu : self
      LibQt6.qt6cr_push_button_show_menu(to_unsafe)
      self
    end

    # Qt-style alias for `menu=`.
    def set_menu(value : Menu?) : self
      self.menu = value
      self
    end

    # Qt-style alias for `default=`.
    def set_default(value : Bool) : self
      self.default = value
      self
    end

    # Qt-style alias for `auto_default=`.
    def set_auto_default(value : Bool) : self
      self.auto_default = value
      self
    end

    # Qt-style alias for `flat=`.
    def set_flat(value : Bool) : self
      self.flat = value
      self
    end
  end
end
