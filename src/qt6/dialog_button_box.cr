module Qt6
  # Wraps `QDialogButtonBox`.
  class DialogButtonBox < Widget
    @clicked : Signal(AbstractButton?) = Signal(AbstractButton?).new
    @help_requested : Signal() = Signal().new
    @accepted : Signal() = Signal().new
    @rejected : Signal() = Signal().new
    @clicked_userdata : LibQt6::Handle = Pointer(Void).null
    @help_requested_userdata : LibQt6::Handle = Pointer(Void).null
    @accepted_userdata : LibQt6::Handle = Pointer(Void).null
    @rejected_userdata : LibQt6::Handle = Pointer(Void).null

    # Signal emitted when any button in the box is clicked.
    getter clicked : Signal(AbstractButton?)
    # Signal emitted when a help-role button is activated.
    getter help_requested : Signal()
    # Signal emitted when an accept-role standard button is clicked.
    getter accepted : Signal()
    # Signal emitted when a reject-role standard button is clicked.
    getter rejected : Signal()

    # Creates an empty dialog button box.
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_dialog_button_box_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      register_callbacks
    end

    # Creates a dialog button box with the given orientation.
    def initialize(orientation : Orientation, parent : Widget? = nil)
      super(LibQt6.qt6cr_dialog_button_box_create_with_orientation(parent.try(&.to_unsafe) || Pointer(Void).null, orientation.value), parent.nil?)
      register_callbacks
    end

    # Creates a dialog button box with the given standard buttons.
    def initialize(buttons : DialogButtonBoxStandardButton, parent : Widget? = nil)
      super(LibQt6.qt6cr_dialog_button_box_create_with_buttons(parent.try(&.to_unsafe) || Pointer(Void).null, buttons.value), parent.nil?)
      register_callbacks
    end

    # Creates a dialog button box with the given buttons and orientation.
    def initialize(buttons : DialogButtonBoxStandardButton, orientation : Orientation, parent : Widget? = nil)
      super(LibQt6.qt6cr_dialog_button_box_create_with_buttons_orientation(parent.try(&.to_unsafe) || Pointer(Void).null, buttons.value, orientation.value), parent.nil?)
      register_callbacks
    end

    private def register_callbacks : Nil
      @clicked = Signal(AbstractButton?).new
      @help_requested = Signal().new
      @accepted = Signal().new
      @rejected = Signal().new
      @clicked_userdata = Box.box(self)
      @help_requested_userdata = Box.box(self)
      @accepted_userdata = Box.box(self)
      @rejected_userdata = Box.box(self)
      LibQt6.qt6cr_dialog_button_box_on_clicked(to_unsafe, CLICKED_TRAMPOLINE, @clicked_userdata)
      LibQt6.qt6cr_dialog_button_box_on_help_requested(to_unsafe, HELP_REQUESTED_TRAMPOLINE, @help_requested_userdata)
      LibQt6.qt6cr_dialog_button_box_on_accepted(to_unsafe, ACCEPTED_TRAMPOLINE, @accepted_userdata)
      LibQt6.qt6cr_dialog_button_box_on_rejected(to_unsafe, REJECTED_TRAMPOLINE, @rejected_userdata)
    end

    # Adds an existing button with the given role and returns it.
    def add_button(button : AbstractButton, role : DialogButtonBoxButtonRole) : AbstractButton
      LibQt6.qt6cr_dialog_button_box_add_button(to_unsafe, button.to_unsafe, role.value)
      button.adopt_by_parent!
      button
    end

    # Adds a new push button with the given text and role.
    def add_button(text : String, role : DialogButtonBoxButtonRole) : PushButton
      PushButton.wrap(LibQt6.qt6cr_dialog_button_box_add_text_button(to_unsafe, text.to_unsafe, role.value))
    end

    # Adds a standard button and returns its widget.
    def add_button(button : DialogButtonBoxStandardButton) : PushButton
      PushButton.wrap(LibQt6.qt6cr_dialog_button_box_add_standard_button(to_unsafe, button.value))
    end

    # Removes the given button from the box and returns it.
    def remove_button(button : AbstractButton) : AbstractButton
      LibQt6.qt6cr_dialog_button_box_remove_button(to_unsafe, button.to_unsafe)
      button
    end

    # Removes all buttons from the box.
    def clear : self
      LibQt6.qt6cr_dialog_button_box_clear(to_unsafe)
      self
    end

    # Returns every button currently in the box.
    def buttons : Array(AbstractButton)
      Qt6.copy_and_release_handles(LibQt6.qt6cr_dialog_button_box_buttons(to_unsafe)).map do |handle|
        AbstractButton.wrap(handle)
      end
    end

    # Returns the role Qt has assigned to the given button.
    def button_role(button : AbstractButton) : DialogButtonBoxButtonRole
      DialogButtonBoxButtonRole.from_value(LibQt6.qt6cr_dialog_button_box_button_role(to_unsafe, button.to_unsafe))
    end

    # Returns the standard-button identity for the given button, if any.
    def standard_button(button : AbstractButton) : DialogButtonBoxStandardButton
      DialogButtonBoxStandardButton.from_value(LibQt6.qt6cr_dialog_button_box_standard_button(to_unsafe, button.to_unsafe))
    end

    # Returns the push button for the requested standard button, if present.
    def button(which : DialogButtonBoxStandardButton) : PushButton?
      handle = LibQt6.qt6cr_dialog_button_box_button(to_unsafe, which.value)
      handle.null? ? nil : PushButton.wrap(handle)
    end

    # Returns the currently configured standard buttons.
    def standard_buttons : DialogButtonBoxStandardButton
      DialogButtonBoxStandardButton.from_value(LibQt6.qt6cr_dialog_button_box_standard_buttons(to_unsafe))
    end

    # Replaces the standard buttons in the button box.
    def standard_buttons=(value : DialogButtonBoxStandardButton) : DialogButtonBoxStandardButton
      LibQt6.qt6cr_dialog_button_box_set_standard_buttons(to_unsafe, value.value)
      value
    end

    # Returns `true` when buttons are centered instead of trailing-aligned.
    def center_buttons? : Bool
      LibQt6.qt6cr_dialog_button_box_center_buttons(to_unsafe)
    end

    # Enables or disables centered button layout.
    def center_buttons=(value : Bool) : Bool
      LibQt6.qt6cr_dialog_button_box_set_center_buttons(to_unsafe, value)
      value
    end

    # Returns the button-box layout orientation.
    def orientation : Orientation
      Orientation.from_value(LibQt6.qt6cr_dialog_button_box_orientation(to_unsafe))
    end

    # Sets the button-box layout orientation.
    def orientation=(value : Orientation) : Orientation
      LibQt6.qt6cr_dialog_button_box_set_orientation(to_unsafe, value.value)
      value
    end

    # Registers a block to run when the button box is accepted.
    def on_accepted(&block : ->) : self
      @accepted.connect { block.call }
      self
    end

    # Registers a block to run when any button in the box is clicked.
    def on_clicked(&block : AbstractButton? ->) : self
      @clicked.connect { |button| block.call(button) }
      self
    end

    # Registers a block to run when a help-role button is triggered.
    def on_help_requested(&block : ->) : self
      @help_requested.connect { block.call }
      self
    end

    # Registers a block to run when the button box is rejected.
    def on_rejected(&block : ->) : self
      @rejected.connect { block.call }
      self
    end

    protected def emit_clicked(handle : LibQt6::Handle) : Nil
      button = handle.null? ? nil : AbstractButton.wrap(handle)
      @clicked.emit(button)
    end

    protected def emit_help_requested : Nil
      @help_requested.emit
    end

    protected def emit_accepted : Nil
      @accepted.emit
    end

    protected def emit_rejected : Nil
      @rejected.emit
    end

    private CLICKED_TRAMPOLINE = ->(userdata : Void*, handle : Void*) do
      Box(DialogButtonBox).unbox(userdata).emit_clicked(handle)
    end

    private HELP_REQUESTED_TRAMPOLINE = ->(userdata : Void*) do
      Box(DialogButtonBox).unbox(userdata).emit_help_requested
    end

    private ACCEPTED_TRAMPOLINE = ->(userdata : Void*) do
      Box(DialogButtonBox).unbox(userdata).emit_accepted
    end

    private REJECTED_TRAMPOLINE = ->(userdata : Void*) do
      Box(DialogButtonBox).unbox(userdata).emit_rejected
    end
  end
end
