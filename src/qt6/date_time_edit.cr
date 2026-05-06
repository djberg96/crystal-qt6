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

    def minimum_date_time : QDateTime
      QDateTime.wrap(LibQt6.qt6cr_date_time_edit_minimum_date_time(to_unsafe), true)
    end

    def minimum_date_time=(value : QDateTime) : QDateTime
      LibQt6.qt6cr_date_time_edit_set_minimum_date_time(to_unsafe, value.to_unsafe)
      value
    end

    def clear_minimum_date_time : self
      LibQt6.qt6cr_date_time_edit_clear_minimum_date_time(to_unsafe)
      self
    end

    def maximum_date_time : QDateTime
      QDateTime.wrap(LibQt6.qt6cr_date_time_edit_maximum_date_time(to_unsafe), true)
    end

    def maximum_date_time=(value : QDateTime) : QDateTime
      LibQt6.qt6cr_date_time_edit_set_maximum_date_time(to_unsafe, value.to_unsafe)
      value
    end

    def clear_maximum_date_time : self
      LibQt6.qt6cr_date_time_edit_clear_maximum_date_time(to_unsafe)
      self
    end

    def set_date_time_range(minimum : QDateTime, maximum : QDateTime) : self
      LibQt6.qt6cr_date_time_edit_set_date_time_range(to_unsafe, minimum.to_unsafe, maximum.to_unsafe)
      self
    end

    def minimum_date : QDate
      QDate.wrap(LibQt6.qt6cr_date_time_edit_minimum_date(to_unsafe), true)
    end

    def minimum_date=(value : QDate) : QDate
      LibQt6.qt6cr_date_time_edit_set_minimum_date(to_unsafe, value.to_unsafe)
      value
    end

    def clear_minimum_date : self
      LibQt6.qt6cr_date_time_edit_clear_minimum_date(to_unsafe)
      self
    end

    def maximum_date : QDate
      QDate.wrap(LibQt6.qt6cr_date_time_edit_maximum_date(to_unsafe), true)
    end

    def maximum_date=(value : QDate) : QDate
      LibQt6.qt6cr_date_time_edit_set_maximum_date(to_unsafe, value.to_unsafe)
      value
    end

    def clear_maximum_date : self
      LibQt6.qt6cr_date_time_edit_clear_maximum_date(to_unsafe)
      self
    end

    def set_date_range(minimum : QDate, maximum : QDate) : self
      LibQt6.qt6cr_date_time_edit_set_date_range(to_unsafe, minimum.to_unsafe, maximum.to_unsafe)
      self
    end

    def minimum_time : QTime
      QTime.wrap(LibQt6.qt6cr_date_time_edit_minimum_time(to_unsafe), true)
    end

    def minimum_time=(value : QTime) : QTime
      LibQt6.qt6cr_date_time_edit_set_minimum_time(to_unsafe, value.to_unsafe)
      value
    end

    def clear_minimum_time : self
      LibQt6.qt6cr_date_time_edit_clear_minimum_time(to_unsafe)
      self
    end

    def maximum_time : QTime
      QTime.wrap(LibQt6.qt6cr_date_time_edit_maximum_time(to_unsafe), true)
    end

    def maximum_time=(value : QTime) : QTime
      LibQt6.qt6cr_date_time_edit_set_maximum_time(to_unsafe, value.to_unsafe)
      value
    end

    def clear_maximum_time : self
      LibQt6.qt6cr_date_time_edit_clear_maximum_time(to_unsafe)
      self
    end

    def set_time_range(minimum : QTime, maximum : QTime) : self
      LibQt6.qt6cr_date_time_edit_set_time_range(to_unsafe, minimum.to_unsafe, maximum.to_unsafe)
      self
    end

    def displayed_sections : DateTimeEditSection
      DateTimeEditSection.from_value(LibQt6.qt6cr_date_time_edit_displayed_sections(to_unsafe))
    end

    def current_section : DateTimeEditSection
      DateTimeEditSection.from_value(LibQt6.qt6cr_date_time_edit_current_section(to_unsafe))
    end

    def current_section=(value : DateTimeEditSection) : DateTimeEditSection
      LibQt6.qt6cr_date_time_edit_set_current_section(to_unsafe, value.value)
      value
    end

    def section_at(index : Int) : DateTimeEditSection
      DateTimeEditSection.from_value(LibQt6.qt6cr_date_time_edit_section_at(to_unsafe, index.to_i32))
    end

    def current_section_index : Int32
      LibQt6.qt6cr_date_time_edit_current_section_index(to_unsafe)
    end

    def current_section_index=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_date_time_edit_set_current_section_index(to_unsafe, int_value)
      int_value
    end

    def calendar_widget : CalendarWidget?
      handle = LibQt6.qt6cr_date_time_edit_calendar_widget(to_unsafe)
      handle.null? ? nil : CalendarWidget.wrap(handle)
    end

    def calendar_widget=(widget : CalendarWidget?) : CalendarWidget?
      LibQt6.qt6cr_date_time_edit_set_calendar_widget(to_unsafe, widget.try(&.to_unsafe) || Pointer(Void).null)
      widget
    end

    def section_count : Int32
      LibQt6.qt6cr_date_time_edit_section_count(to_unsafe)
    end

    def selected_section=(value : DateTimeEditSection) : DateTimeEditSection
      LibQt6.qt6cr_date_time_edit_set_selected_section(to_unsafe, value.value)
      value
    end

    def section_text(section : DateTimeEditSection) : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_date_time_edit_section_text(to_unsafe, section.value))
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
