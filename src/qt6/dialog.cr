module Qt6
  # Wraps `QDialog` and exposes accepted/rejected callbacks.
  class Dialog < Widget
    @accepted : Signal() = Signal().new
    @rejected : Signal() = Signal().new
    @accepted_userdata : LibQt6::Handle = Pointer(Void).null
    @rejected_userdata : LibQt6::Handle = Pointer(Void).null

    # Signal emitted when the dialog is accepted.
    getter accepted : Signal()
    # Signal emitted when the dialog is rejected.
    getter rejected : Signal()

    # Creates a dialog with an optional parent widget.
    def initialize(parent : Widget? = nil)
      initialize(LibQt6.qt6cr_dialog_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      register_callbacks
    end

    private def register_callbacks : Nil
      @accepted = Signal().new
      @rejected = Signal().new
      @accepted_userdata = Box.box(self)
      @rejected_userdata = Box.box(self)
      LibQt6.qt6cr_dialog_on_accepted(to_unsafe, ACCEPTED_TRAMPOLINE, @accepted_userdata)
      LibQt6.qt6cr_dialog_on_rejected(to_unsafe, REJECTED_TRAMPOLINE, @rejected_userdata)
    end

    # Runs the dialog modally and returns the resulting `DialogCode`.
    def exec : DialogCode
      DialogCode.from_value(LibQt6.qt6cr_dialog_exec(to_unsafe))
    end

    # Returns the current dialog result.
    def result : DialogCode
      DialogCode.from_value(LibQt6.qt6cr_dialog_result(to_unsafe))
    end

    # Accepts the dialog.
    def accept : self
      LibQt6.qt6cr_dialog_accept(to_unsafe)
      self
    end

    # Rejects the dialog.
    def reject : self
      LibQt6.qt6cr_dialog_reject(to_unsafe)
      self
    end

    # Registers a block to run when the dialog is accepted.
    def on_accepted(&block : ->) : self
      @accepted.connect { block.call }
      self
    end

    # Registers a block to run when the dialog is rejected.
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
      Box(Dialog).unbox(userdata).emit_accepted
    end

    private REJECTED_TRAMPOLINE = ->(userdata : Void*) do
      Box(Dialog).unbox(userdata).emit_rejected
    end
  end
end
