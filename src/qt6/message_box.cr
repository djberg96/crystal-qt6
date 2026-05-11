module Qt6
  # Wraps `QMessageBox`.
  class MessageBox < Dialog
    # Creates a message box with an optional parent widget.
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_message_box_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    # Returns the current message-box icon.
    def icon : MessageBoxIcon
      MessageBoxIcon.from_value(LibQt6.qt6cr_message_box_icon(to_unsafe))
    end

    # Sets the message-box icon and returns it.
    def icon=(value : MessageBoxIcon) : MessageBoxIcon
      LibQt6.qt6cr_message_box_set_icon(to_unsafe, value.value)
      value
    end

    # Returns the main text shown in the message box.
    def text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_message_box_text(to_unsafe))
    end

    # Sets the main text shown in the message box.
    def text=(value : String) : String
      LibQt6.qt6cr_message_box_set_text(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the secondary informative text.
    def informative_text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_message_box_informative_text(to_unsafe))
    end

    # Sets the secondary informative text.
    def informative_text=(value : String) : String
      LibQt6.qt6cr_message_box_set_informative_text(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the optional detailed text shown from the expandable details area.
    def detailed_text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_message_box_detailed_text(to_unsafe))
    end

    # Sets the optional detailed text shown from the expandable details area.
    def detailed_text=(value : String) : String
      LibQt6.qt6cr_message_box_set_detailed_text(to_unsafe, value.to_unsafe)
      value
    end

    # Adds an existing button with the given role and returns it.
    def add_button(button : AbstractButton, role : DialogButtonBoxButtonRole) : AbstractButton
      LibQt6.qt6cr_message_box_add_button(to_unsafe, button.to_unsafe, role.value)
      button.adopt_by_parent!
      button
    end

    # Adds a new push button with the given text and role.
    def add_button(text : String, role : DialogButtonBoxButtonRole) : PushButton
      PushButton.wrap(LibQt6.qt6cr_message_box_add_text_button(to_unsafe, text.to_unsafe, role.value))
    end

    # Adds a standard button and returns its widget.
    def add_button(button : MessageBoxButton) : PushButton
      PushButton.wrap(LibQt6.qt6cr_message_box_add_standard_button(to_unsafe, button.value))
    end

    # Returns the push button for the requested standard button, if present.
    def button(which : MessageBoxButton) : PushButton?
      handle = LibQt6.qt6cr_message_box_button(to_unsafe, which.value)
      handle.null? ? nil : PushButton.wrap(handle)
    end

    # Returns the role Qt has assigned to the given button.
    def button_role(button : AbstractButton) : DialogButtonBoxButtonRole
      DialogButtonBoxButtonRole.from_value(LibQt6.qt6cr_message_box_button_role(to_unsafe, button.to_unsafe))
    end

    # Returns the standard-button identity for the given button, if any.
    def standard_button(button : AbstractButton) : MessageBoxButton
      MessageBoxButton.from_value(LibQt6.qt6cr_message_box_standard_button(to_unsafe, button.to_unsafe))
    end

    # Returns the current default button, if one is assigned.
    def default_button : PushButton?
      handle = LibQt6.qt6cr_message_box_default_button(to_unsafe)
      handle.null? ? nil : PushButton.wrap(handle)
    end

    # Sets the default push button and returns it.
    def default_button=(value : PushButton?) : PushButton?
      LibQt6.qt6cr_message_box_set_default_button(to_unsafe, value.try(&.to_unsafe) || Pointer(Void).null)
      value
    end

    # Sets the default standard button and returns it.
    def default_button=(value : MessageBoxButton) : MessageBoxButton
      LibQt6.qt6cr_message_box_set_default_standard_button(to_unsafe, value.value)
      value
    end

    # Returns the current escape button, if one is assigned.
    def escape_button : AbstractButton?
      handle = LibQt6.qt6cr_message_box_escape_button(to_unsafe)
      handle.null? ? nil : AbstractButton.wrap(handle)
    end

    # Sets the escape button and returns it.
    def escape_button=(value : AbstractButton?) : AbstractButton?
      LibQt6.qt6cr_message_box_set_escape_button(to_unsafe, value.try(&.to_unsafe) || Pointer(Void).null)
      value
    end

    # Sets the escape standard button and returns it.
    def escape_button=(value : MessageBoxButton) : MessageBoxButton
      LibQt6.qt6cr_message_box_set_escape_standard_button(to_unsafe, value.value)
      value
    end

    # Returns the enabled standard buttons.
    def standard_buttons : MessageBoxButton
      MessageBoxButton.from_value(LibQt6.qt6cr_message_box_standard_buttons(to_unsafe))
    end

    # Sets the enabled standard buttons.
    def standard_buttons=(value : MessageBoxButton) : MessageBoxButton
      LibQt6.qt6cr_message_box_set_standard_buttons(to_unsafe, value.value)
      value
    end

    # Executes the message box modally and returns the pressed button.
    def show_modal : MessageBoxButton
      normalize_exec_result(LibQt6.qt6cr_message_box_exec(to_unsafe))
    end

    # Qt-style alias for `detailed_text=`.
    def set_detailed_text(value : String) : self
      self.detailed_text = value
      self
    end

    # Qt-style alias for `default_button=`.
    def set_default_button(value : PushButton?) : self
      self.default_button = value
      self
    end

    # Qt-style alias for `default_button=` with a standard button identifier.
    def set_default_button(value : MessageBoxButton) : self
      self.default_button = value
      self
    end

    # Qt-style alias for `escape_button=`.
    def set_escape_button(value : AbstractButton?) : self
      self.escape_button = value
      self
    end

    # Qt-style alias for `escape_button=` with a standard button identifier.
    def set_escape_button(value : MessageBoxButton) : self
      self.escape_button = value
      self
    end

    # Shows an information message box and returns the pressed button.
    def self.information(parent : Widget? = nil, *, title : String, text : String, informative_text : String = "", buttons : MessageBoxButton = MessageBoxButton::Ok) : MessageBoxButton
      present(parent, title, text, informative_text, MessageBoxIcon::Information, buttons)
    end

    # Shows an information message box, yields it for customization, and returns
    # the pressed button.
    def self.information(parent : Widget? = nil, *, title : String, text : String, informative_text : String = "", buttons : MessageBoxButton = MessageBoxButton::Ok, &block : MessageBox ->) : MessageBoxButton
      present(parent, title, text, informative_text, MessageBoxIcon::Information) do |dialog|
        dialog.standard_buttons = buttons
        yield dialog
      end
    end

    # Shows a warning message box and returns the pressed button.
    def self.warning(parent : Widget? = nil, *, title : String, text : String, informative_text : String = "", buttons : MessageBoxButton = MessageBoxButton::Ok) : MessageBoxButton
      present(parent, title, text, informative_text, MessageBoxIcon::Warning, buttons)
    end

    # Shows a warning message box, yields it for customization, and returns the
    # pressed button.
    def self.warning(parent : Widget? = nil, *, title : String, text : String, informative_text : String = "", buttons : MessageBoxButton = MessageBoxButton::Ok, &block : MessageBox ->) : MessageBoxButton
      present(parent, title, text, informative_text, MessageBoxIcon::Warning) do |dialog|
        dialog.standard_buttons = buttons
        yield dialog
      end
    end

    # Shows a critical message box and returns the pressed button.
    def self.critical(parent : Widget? = nil, *, title : String, text : String, informative_text : String = "", buttons : MessageBoxButton = MessageBoxButton::Ok) : MessageBoxButton
      present(parent, title, text, informative_text, MessageBoxIcon::Critical, buttons)
    end

    # Shows a critical message box, yields it for customization, and returns the
    # pressed button.
    def self.critical(parent : Widget? = nil, *, title : String, text : String, informative_text : String = "", buttons : MessageBoxButton = MessageBoxButton::Ok, &block : MessageBox ->) : MessageBoxButton
      present(parent, title, text, informative_text, MessageBoxIcon::Critical) do |dialog|
        dialog.standard_buttons = buttons
        yield dialog
      end
    end

    # Shows a question message box and returns the pressed button.
    def self.question(parent : Widget? = nil, *, title : String, text : String, informative_text : String = "", buttons : MessageBoxButton = MessageBoxButton::Yes | MessageBoxButton::No) : MessageBoxButton
      present(parent, title, text, informative_text, MessageBoxIcon::Question, buttons)
    end

    # Shows a question message box, yields it for customization, and returns the
    # pressed button.
    def self.question(parent : Widget? = nil, *, title : String, text : String, informative_text : String = "", buttons : MessageBoxButton = MessageBoxButton::Yes | MessageBoxButton::No, &block : MessageBox ->) : MessageBoxButton
      present(parent, title, text, informative_text, MessageBoxIcon::Question) do |dialog|
        dialog.standard_buttons = buttons
        yield dialog
      end
    end

    private def self.present(parent : Widget?, title : String, text : String, informative_text : String, icon : MessageBoxIcon, buttons : MessageBoxButton) : MessageBoxButton
      dialog = new(parent)
      dialog.window_title = title
      dialog.icon = icon
      dialog.text = text
      dialog.informative_text = informative_text
      dialog.standard_buttons = buttons
      begin
        dialog.show_modal
      ensure
        dialog.release
      end
    end

    private def self.present(parent : Widget?, title : String, text : String, informative_text : String, icon : MessageBoxIcon, &block : MessageBox ->) : MessageBoxButton
      dialog = new(parent)
      dialog.window_title = title
      dialog.icon = icon
      dialog.text = text
      dialog.informative_text = informative_text
      begin
        yield dialog
        dialog.show_modal
      ensure
        dialog.release
      end
    end

    private def normalize_exec_result(value : Int32) : MessageBoxButton
      return MessageBoxButton.from_value(value) if value >= MessageBoxButton::Ok.value
      return MessageBoxButton::NoButton if value == DialogCode::Rejected.value

      buttons = standard_buttons
      button_priority = [
        MessageBoxButton::Ok,
        MessageBoxButton::Yes,
        MessageBoxButton::Save,
        MessageBoxButton::Open,
        MessageBoxButton::Apply,
        MessageBoxButton::Retry,
        MessageBoxButton::Ignore,
        MessageBoxButton::Close,
        MessageBoxButton::Cancel,
        MessageBoxButton::No,
        MessageBoxButton::Discard,
        MessageBoxButton::Help,
        MessageBoxButton::Reset,
        MessageBoxButton::RestoreDefaults,
      ]

      button_priority.each do |button|
        return button if buttons.includes?(button)
      end

      MessageBoxButton::NoButton
    end
  end
end
