module Qt6
  # Wraps `QDateEdit`.
  class DateEdit < DateTimeEdit
    @date_changed : Signal(QDate) = Signal(QDate).new
    @date_callback_userdata : LibQt6::Handle = Pointer(Void).null

    getter date_changed : Signal(QDate)

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_date_edit_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      @date_changed = Signal(QDate).new
      @date_callback_userdata = Box.box(self)
      LibQt6.qt6cr_date_edit_on_date_changed(to_unsafe, DATE_CHANGED_TRAMPOLINE, @date_callback_userdata)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      @date_changed = Signal(QDate).new
      @date_callback_userdata = Box.box(self)
      LibQt6.qt6cr_date_edit_on_date_changed(to_unsafe, DATE_CHANGED_TRAMPOLINE, @date_callback_userdata)
    end

    def on_date_changed(&block : QDate ->) : self
      @date_changed.connect { |value| block.call(value) }
      self
    end

    protected def emit_date_changed(handle : LibQt6::Handle) : Nil
      @date_changed.emit(QDate.wrap(handle, true))
    end

    private DATE_CHANGED_TRAMPOLINE = ->(userdata : Void*, handle : Void*) do
      Box(DateEdit).unbox(userdata).emit_date_changed(handle)
    end
  end
end
