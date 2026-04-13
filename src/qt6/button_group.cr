module Qt6
  # Wraps `QButtonGroup` for grouped mode buttons.
  class ButtonGroup < QObject
    # Creates a button group, optionally parented to another object.
    def initialize(parent : QObject? = nil)
      super(LibQt6.qt6cr_button_group_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    # Returns `true` when only one button in the group can stay checked.
    def exclusive? : Bool
      LibQt6.qt6cr_button_group_is_exclusive(to_unsafe)
    end

    # Enables or disables exclusive checked-button behavior.
    def exclusive=(value : Bool) : Bool
      LibQt6.qt6cr_button_group_set_exclusive(to_unsafe, value)
      value
    end

    # Adds a button to the group and optionally assigns a stable id.
    def add(button : Widget, id : Int32 = -1) : Widget
      LibQt6.qt6cr_button_group_add_button(to_unsafe, button.to_unsafe, id)
      button
    end

    # Returns the grouped button for the given id, if one exists.
    def button(id : Int32) : AbstractButton?
      handle = LibQt6.qt6cr_button_group_button(to_unsafe, id)
      handle.null? ? nil : AbstractButton.wrap(handle)
    end

    # Returns the currently checked button id, or `-1` when nothing is checked.
    def checked_id : Int32
      LibQt6.qt6cr_button_group_checked_id(to_unsafe)
    end
  end
end
