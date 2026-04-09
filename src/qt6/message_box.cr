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
  end
end
