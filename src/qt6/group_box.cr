module Qt6
  # Wraps `QGroupBox`.
  class GroupBox < Widget
    @toggled : Signal(Bool) = Signal(Bool).new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    # Signal emitted whenever the checked state changes on a checkable group box.
    getter toggled : Signal(Bool)

    # Creates a group box with optional title and parent.
    def initialize(title : String = "", parent : Widget? = nil)
      super(LibQt6.qt6cr_group_box_create(parent.try(&.to_unsafe) || Pointer(Void).null, title.to_unsafe), parent.nil?)
      @toggled = Signal(Bool).new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_group_box_on_toggled(to_unsafe, TOGGLED_TRAMPOLINE, @callback_userdata)
    end

    # Returns the group-box title.
    def title : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_group_box_title(to_unsafe))
    end

    # Sets the group-box title and returns the assigned value.
    def title=(value : String) : String
      LibQt6.qt6cr_group_box_set_title(to_unsafe, value.to_unsafe)
      value
    end

    # Returns `true` when the group box shows a checkbox in its title.
    def checkable? : Bool
      LibQt6.qt6cr_group_box_is_checkable(to_unsafe)
    end

    # Enables or disables the group-box checkbox.
    def checkable=(value : Bool) : Bool
      LibQt6.qt6cr_group_box_set_checkable(to_unsafe, value)
      value
    end

    # Returns `true` when the group box is checked.
    def checked? : Bool
      LibQt6.qt6cr_group_box_is_checked(to_unsafe)
    end

    # Sets the group-box checked state.
    def checked=(value : Bool) : Bool
      LibQt6.qt6cr_group_box_set_checked(to_unsafe, value)
      value
    end

    # Registers a block to run when the group-box checked state changes.
    def on_toggled(&block : Bool ->) : self
      @toggled.connect { |value| block.call(value) }
      self
    end

    protected def emit_toggled(value : Bool) : Nil
      @toggled.emit(value)
    end

    private TOGGLED_TRAMPOLINE = ->(userdata : Void*, value : Bool) do
      Box(GroupBox).unbox(userdata).emit_toggled(value)
    end
  end
end