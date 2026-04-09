module Qt6
  class Dialog < Widget
    @accepted : Signal() = Signal().new
    @rejected : Signal() = Signal().new
    @accepted_userdata : LibQt6::Handle = Pointer(Void).null
    @rejected_userdata : LibQt6::Handle = Pointer(Void).null

    getter accepted : Signal()
    getter rejected : Signal()

    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_dialog_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      @accepted = Signal().new
      @rejected = Signal().new
      @accepted_userdata = Box.box(self)
      @rejected_userdata = Box.box(self)
      LibQt6.qt6cr_dialog_on_accepted(to_unsafe, ACCEPTED_TRAMPOLINE, @accepted_userdata)
      LibQt6.qt6cr_dialog_on_rejected(to_unsafe, REJECTED_TRAMPOLINE, @rejected_userdata)
    end

    def exec : DialogCode
      DialogCode.from_value(LibQt6.qt6cr_dialog_exec(to_unsafe))
    end

    def result : DialogCode
      DialogCode.from_value(LibQt6.qt6cr_dialog_result(to_unsafe))
    end

    def accept : self
      LibQt6.qt6cr_dialog_accept(to_unsafe)
      self
    end

    def reject : self
      LibQt6.qt6cr_dialog_reject(to_unsafe)
      self
    end

    def on_accepted(&block : ->) : self
      @accepted.connect { block.call }
      self
    end

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
