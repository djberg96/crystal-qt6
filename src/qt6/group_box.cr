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

    # Qt-style alias for `title=`.
    def set_title(value : String) : self
      self.title = value
      self
    end

    # Returns the group-box title alignment flags.
    def alignment : AlignmentFlag
      AlignmentFlag.from_value(LibQt6.qt6cr_group_box_alignment(to_unsafe))
    end

    # Sets the group-box title alignment and returns it.
    def alignment=(value : AlignmentFlag) : AlignmentFlag
      LibQt6.qt6cr_group_box_set_alignment(to_unsafe, value.value)
      value
    end

    # Qt-style alias for `alignment=`.
    def set_alignment(value : AlignmentFlag) : self
      self.alignment = value
      self
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

    # Qt-style alias for `checkable=`.
    def set_checkable(value : Bool) : self
      self.checkable = value
      self
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

    # Qt-style alias for `checked=`.
    def set_checked(value : Bool) : self
      self.checked = value
      self
    end

    # Returns `true` when the group box hides the frame side lines.
    def flat? : Bool
      LibQt6.qt6cr_group_box_is_flat(to_unsafe)
    end

    # Enables or disables flat frame styling.
    def flat=(value : Bool) : Bool
      LibQt6.qt6cr_group_box_set_flat(to_unsafe, value)
      value
    end

    # Qt-style alias for `flat=`.
    def set_flat(value : Bool) : self
      self.flat = value
      self
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
