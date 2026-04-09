module Qt6
  class MessageBox < Dialog
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_message_box_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    def icon : MessageBoxIcon
      MessageBoxIcon.from_value(LibQt6.qt6cr_message_box_icon(to_unsafe))
    end

    def icon=(value : MessageBoxIcon) : MessageBoxIcon
      LibQt6.qt6cr_message_box_set_icon(to_unsafe, value.value)
      value
    end

    def text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_message_box_text(to_unsafe))
    end

    def text=(value : String) : String
      LibQt6.qt6cr_message_box_set_text(to_unsafe, value.to_unsafe)
      value
    end

    def informative_text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_message_box_informative_text(to_unsafe))
    end

    def informative_text=(value : String) : String
      LibQt6.qt6cr_message_box_set_informative_text(to_unsafe, value.to_unsafe)
      value
    end

    def standard_buttons : MessageBoxButton
      MessageBoxButton.from_value(LibQt6.qt6cr_message_box_standard_buttons(to_unsafe))
    end

    def standard_buttons=(value : MessageBoxButton) : MessageBoxButton
      LibQt6.qt6cr_message_box_set_standard_buttons(to_unsafe, value.value)
      value
    end

    def show_modal : MessageBoxButton
      normalize_exec_result(LibQt6.qt6cr_message_box_exec(to_unsafe))
    end

    def self.information(parent : Widget? = nil, *, title : String, text : String, informative_text : String = "", buttons : MessageBoxButton = MessageBoxButton::Ok) : MessageBoxButton
      present(parent, title, text, informative_text, MessageBoxIcon::Information, buttons)
    end

    def self.information(parent : Widget? = nil, *, title : String, text : String, informative_text : String = "", buttons : MessageBoxButton = MessageBoxButton::Ok, &block : MessageBox ->) : MessageBoxButton
      present(parent, title, text, informative_text, MessageBoxIcon::Information) do |dialog|
        dialog.standard_buttons = buttons
        yield dialog
      end
    end

    def self.warning(parent : Widget? = nil, *, title : String, text : String, informative_text : String = "", buttons : MessageBoxButton = MessageBoxButton::Ok) : MessageBoxButton
      present(parent, title, text, informative_text, MessageBoxIcon::Warning, buttons)
    end

    def self.warning(parent : Widget? = nil, *, title : String, text : String, informative_text : String = "", buttons : MessageBoxButton = MessageBoxButton::Ok, &block : MessageBox ->) : MessageBoxButton
      present(parent, title, text, informative_text, MessageBoxIcon::Warning) do |dialog|
        dialog.standard_buttons = buttons
        yield dialog
      end
    end

    def self.critical(parent : Widget? = nil, *, title : String, text : String, informative_text : String = "", buttons : MessageBoxButton = MessageBoxButton::Ok) : MessageBoxButton
      present(parent, title, text, informative_text, MessageBoxIcon::Critical, buttons)
    end

    def self.critical(parent : Widget? = nil, *, title : String, text : String, informative_text : String = "", buttons : MessageBoxButton = MessageBoxButton::Ok, &block : MessageBox ->) : MessageBoxButton
      present(parent, title, text, informative_text, MessageBoxIcon::Critical) do |dialog|
        dialog.standard_buttons = buttons
        yield dialog
      end
    end

    def self.question(parent : Widget? = nil, *, title : String, text : String, informative_text : String = "", buttons : MessageBoxButton = MessageBoxButton::Yes | MessageBoxButton::No) : MessageBoxButton
      present(parent, title, text, informative_text, MessageBoxIcon::Question, buttons)
    end

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
