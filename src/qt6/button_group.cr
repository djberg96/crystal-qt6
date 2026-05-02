module Qt6
  # Wraps `QButtonGroup` for grouped mode buttons.
  class ButtonGroup < QObject
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a button group, optionally parented to another object.
    def initialize(parent : QObject? = nil)
      super(LibQt6.qt6cr_button_group_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
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

    # Returns the currently checked button, if one exists.
    def checked_button : AbstractButton?
      handle = LibQt6.qt6cr_button_group_checked_button(to_unsafe)
      handle.null? ? nil : AbstractButton.wrap(handle)
    end

    # Returns the current group id for the given button, or `-1` when absent.
    def id(button : AbstractButton) : Int32
      LibQt6.qt6cr_button_group_id(to_unsafe, button.to_unsafe)
    end

    # Reassigns the given button's group id and returns it.
    def set_id(button : AbstractButton, id : Int32) : Int32
      LibQt6.qt6cr_button_group_set_id(to_unsafe, button.to_unsafe, id)
      id
    end

    # Removes a button from the group and returns it.
    def remove(button : AbstractButton) : AbstractButton
      LibQt6.qt6cr_button_group_remove_button(to_unsafe, button.to_unsafe)
      button
    end
  end
end
