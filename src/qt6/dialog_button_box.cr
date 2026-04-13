module Qt6
  # Wraps `QDialogButtonBox`.
  class DialogButtonBox < Widget
    @accepted : Signal() = Signal().new
    @rejected : Signal() = Signal().new
    @accepted_userdata : LibQt6::Handle = Pointer(Void).null
    @rejected_userdata : LibQt6::Handle = Pointer(Void).null

    # Signal emitted when an accept-role standard button is clicked.
    getter accepted : Signal()
    # Signal emitted when a reject-role standard button is clicked.
    getter rejected : Signal()

    # Creates a dialog button box with the given standard buttons.
    def initialize(buttons : DialogButtonBoxStandardButton, parent : Widget? = nil)
      super(LibQt6.qt6cr_dialog_button_box_create(parent.try(&.to_unsafe) || Pointer(Void).null, buttons.value), parent.nil?)
      @accepted = Signal().new
      @rejected = Signal().new
      @accepted_userdata = Box.box(self)
      @rejected_userdata = Box.box(self)
      LibQt6.qt6cr_dialog_button_box_on_accepted(to_unsafe, ACCEPTED_TRAMPOLINE, @accepted_userdata)
      LibQt6.qt6cr_dialog_button_box_on_rejected(to_unsafe, REJECTED_TRAMPOLINE, @rejected_userdata)
    end

    # Returns the push button for the requested standard button, if present.
    def button(which : DialogButtonBoxStandardButton) : PushButton?
      handle = LibQt6.qt6cr_dialog_button_box_button(to_unsafe, which.value)
      handle.null? ? nil : PushButton.wrap(handle)
    end

    # Registers a block to run when the button box is accepted.
    def on_accepted(&block : ->) : self
      @accepted.connect { block.call }
      self
    end

    # Registers a block to run when the button box is rejected.
    def on_rejected(&block : ->) : self
      @rejected.connect { block.call }
      self
    end

    protected def emit_accepted : Nil
      @accepted.emit
    end

    protected def emit_rejected : Nil
      @rejected.emit
    end

    private ACCEPTED_TRAMPOLINE = ->(userdata : Void*) do
      Box(DialogButtonBox).unbox(userdata).emit_accepted
    end

    private REJECTED_TRAMPOLINE = ->(userdata : Void*) do
      Box(DialogButtonBox).unbox(userdata).emit_rejected
    end
  end
end
