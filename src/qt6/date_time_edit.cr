module Qt6
  # Wraps `QDateTimeEdit`.
  class DateTimeEdit < AbstractSpinBox
    @date_time_changed : Signal(QDateTime) = Signal(QDateTime).new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    getter date_time_changed : Signal(QDateTime)

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_date_time_edit_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      @date_time_changed = Signal(QDateTime).new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_date_time_edit_on_date_time_changed(to_unsafe, DATE_TIME_CHANGED_TRAMPOLINE, @callback_userdata)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      @date_time_changed = Signal(QDateTime).new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_date_time_edit_on_date_time_changed(to_unsafe, DATE_TIME_CHANGED_TRAMPOLINE, @callback_userdata)
    end

    def display_format : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_date_time_edit_display_format(to_unsafe))
    end

    def display_format=(value : String) : String
      LibQt6.qt6cr_date_time_edit_set_display_format(to_unsafe, value.to_unsafe)
      value
    end

    def calendar_popup? : Bool
      LibQt6.qt6cr_date_time_edit_calendar_popup(to_unsafe)
    end

    def calendar_popup=(value : Bool) : Bool
      LibQt6.qt6cr_date_time_edit_set_calendar_popup(to_unsafe, value)
      value
    end

    def date : QDate
      QDate.wrap(LibQt6.qt6cr_date_time_edit_date(to_unsafe), true)
    end

    def date=(value : QDate) : QDate
      LibQt6.qt6cr_date_time_edit_set_date(to_unsafe, value.to_unsafe)
      value
    end

    def time : QTime
      QTime.wrap(LibQt6.qt6cr_date_time_edit_time(to_unsafe), true)
    end

    def time=(value : QTime) : QTime
      LibQt6.qt6cr_date_time_edit_set_time(to_unsafe, value.to_unsafe)
      value
    end

    def date_time : QDateTime
      QDateTime.wrap(LibQt6.qt6cr_date_time_edit_date_time(to_unsafe), true)
    end

    def date_time=(value : QDateTime) : QDateTime
      LibQt6.qt6cr_date_time_edit_set_date_time(to_unsafe, value.to_unsafe)
      value
    end

    def on_date_time_changed(&block : QDateTime ->) : self
      @date_time_changed.connect { |value| block.call(value) }
      self
    end

    protected def emit_date_time_changed(handle : LibQt6::Handle) : Nil
      @date_time_changed.emit(QDateTime.wrap(handle, true))
    end

    private DATE_TIME_CHANGED_TRAMPOLINE = ->(userdata : Void*, handle : Void*) do
      Box(DateTimeEdit).unbox(userdata).emit_date_time_changed(handle)
    end
  end
end
