module Qt6
  # Wraps `QDialog` and exposes accepted/rejected callbacks.
  class Dialog < Widget
    @finished : Signal(DialogCode) = Signal(DialogCode).new
    @accepted : Signal() = Signal().new
    @rejected : Signal() = Signal().new
    @finished_userdata : LibQt6::Handle = Pointer(Void).null
    @accepted_userdata : LibQt6::Handle = Pointer(Void).null
    @rejected_userdata : LibQt6::Handle = Pointer(Void).null

    # Signal emitted when the dialog finishes with either acceptance or rejection.
    getter finished : Signal(DialogCode)
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
      @finished = Signal(DialogCode).new
      @accepted = Signal().new
      @rejected = Signal().new
      @finished_userdata = Box.box(self)
      @accepted_userdata = Box.box(self)
      @rejected_userdata = Box.box(self)
      LibQt6.qt6cr_dialog_on_finished(to_unsafe, FINISHED_TRAMPOLINE, @finished_userdata)
      LibQt6.qt6cr_dialog_on_accepted(to_unsafe, ACCEPTED_TRAMPOLINE, @accepted_userdata)
      LibQt6.qt6cr_dialog_on_rejected(to_unsafe, REJECTED_TRAMPOLINE, @rejected_userdata)
    end

    # Runs the dialog modally and returns the resulting `DialogCode`.
    def exec : DialogCode
      DialogCode.from_value(LibQt6.qt6cr_dialog_exec(to_unsafe))
    end

    # Returns `true` when the resize grip is enabled.
    def size_grip_enabled? : Bool
      LibQt6.qt6cr_dialog_is_size_grip_enabled(to_unsafe)
    end

    # Enables or disables the resize grip.
    def size_grip_enabled=(value : Bool) : Bool
      LibQt6.qt6cr_dialog_set_size_grip_enabled(to_unsafe, value)
      value
    end

    # Returns `true` when the dialog is modal.
    def modal? : Bool
      LibQt6.qt6cr_dialog_is_modal(to_unsafe)
    end

    # Enables or disables modal behavior.
    def modal=(value : Bool) : Bool
      LibQt6.qt6cr_dialog_set_modal(to_unsafe, value)
      value
    end

    # Returns the current dialog result.
    def result : DialogCode
      DialogCode.from_value(LibQt6.qt6cr_dialog_result(to_unsafe))
    end

    # Replaces the current dialog result and returns it.
    def result=(value : DialogCode) : DialogCode
      LibQt6.qt6cr_dialog_set_result(to_unsafe, value.value)
      value
    end

    # Opens the dialog asynchronously and returns `self`.
    def open : self
      LibQt6.qt6cr_dialog_open(to_unsafe)
      self
    end

    # Finishes the dialog with the given result code.
    def done(value : DialogCode) : DialogCode
      LibQt6.qt6cr_dialog_done(to_unsafe, value.value)
      value
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

    # Registers a block to run when the dialog finishes.
    def on_finished(&block : DialogCode ->) : self
      @finished.connect { |value| block.call(value) }
      self
    end

    # Registers a block to run when the dialog is rejected.
    def on_rejected(&block : ->) : self
      @rejected.connect { block.call }
      self
    end

    protected def emit_finished(value : Int32) : Nil
      @finished.emit(DialogCode.from_value(value))
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

    private FINISHED_TRAMPOLINE = ->(userdata : Void*, value : Int32) do
      Box(Dialog).unbox(userdata).emit_finished(value)
    end

    private REJECTED_TRAMPOLINE = ->(userdata : Void*) do
      Box(Dialog).unbox(userdata).emit_rejected
    end
  end
end
