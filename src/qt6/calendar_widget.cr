module Qt6
  # Wraps `QCalendarWidget`.
  class CalendarWidget < Widget
    @selection_changed : Signal() = Signal().new
    @clicked : Signal(QDate) = Signal(QDate).new
    @activated : Signal(QDate) = Signal(QDate).new
    @current_page_changed : Signal(Int32, Int32) = Signal(Int32, Int32).new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    getter selection_changed : Signal()
    getter clicked : Signal(QDate)
    getter activated : Signal(QDate)
    getter current_page_changed : Signal(Int32, Int32)

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_calendar_widget_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      register_calendar_callbacks
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      register_calendar_callbacks
    end

    # Returns the currently selected date.
    def selected_date : QDate
      QDate.wrap(LibQt6.qt6cr_calendar_widget_selected_date(to_unsafe), true)
    end

    # Sets the selected date and returns it.
    def selected_date=(value : QDate) : QDate
      LibQt6.qt6cr_calendar_widget_set_selected_date(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the minimum date allowed for selection.
    def minimum_date : QDate
      QDate.wrap(LibQt6.qt6cr_calendar_widget_minimum_date(to_unsafe), true)
    end

    # Sets the minimum date allowed for selection and returns it.
    def minimum_date=(value : QDate) : QDate
      LibQt6.qt6cr_calendar_widget_set_minimum_date(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the maximum date allowed for selection.
    def maximum_date : QDate
      QDate.wrap(LibQt6.qt6cr_calendar_widget_maximum_date(to_unsafe), true)
    end

    # Sets the maximum date allowed for selection and returns it.
    def maximum_date=(value : QDate) : QDate
      LibQt6.qt6cr_calendar_widget_set_maximum_date(to_unsafe, value.to_unsafe)
      value
    end

    # Replaces the allowed date range and returns `self`.
    def set_date_range(minimum : QDate, maximum : QDate) : self
      LibQt6.qt6cr_calendar_widget_set_date_range(to_unsafe, minimum.to_unsafe, maximum.to_unsafe)
      self
    end

    # Returns `true` when the month grid lines are visible.
    def grid_visible? : Bool
      LibQt6.qt6cr_calendar_widget_grid_visible(to_unsafe)
    end

    # Shows or hides the month grid lines.
    def grid_visible=(value : Bool) : Bool
      LibQt6.qt6cr_calendar_widget_set_grid_visible(to_unsafe, value)
      value
    end

    # Returns `true` when the navigation bar is visible.
    def navigation_bar_visible? : Bool
      LibQt6.qt6cr_calendar_widget_navigation_bar_visible(to_unsafe)
    end

    # Shows or hides the navigation bar.
    def navigation_bar_visible=(value : Bool) : Bool
      LibQt6.qt6cr_calendar_widget_set_navigation_bar_visible(to_unsafe, value)
      value
    end

    # Returns `true` when keyboard date editing is enabled.
    def date_edit_enabled? : Bool
      LibQt6.qt6cr_calendar_widget_date_edit_enabled(to_unsafe)
    end

    # Enables or disables keyboard date editing.
    def date_edit_enabled=(value : Bool) : Bool
      LibQt6.qt6cr_calendar_widget_set_date_edit_enabled(to_unsafe, value)
      value
    end

    # Returns the date-edit accept delay in milliseconds.
    def date_edit_accept_delay : Int32
      LibQt6.qt6cr_calendar_widget_date_edit_accept_delay(to_unsafe)
    end

    # Sets the date-edit accept delay and returns it.
    def date_edit_accept_delay=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_calendar_widget_set_date_edit_accept_delay(to_unsafe, int_value)
      int_value
    end

    # Returns the year currently shown in the month view.
    def year_shown : Int32
      LibQt6.qt6cr_calendar_widget_year_shown(to_unsafe)
    end

    # Returns the month currently shown in the month view.
    def month_shown : Int32
      LibQt6.qt6cr_calendar_widget_month_shown(to_unsafe)
    end

    # Jumps the month view to the given year and month and returns `self`.
    def set_current_page(year : Int, month : Int) : self
      LibQt6.qt6cr_calendar_widget_set_current_page(to_unsafe, year.to_i32, month.to_i32)
      self
    end

    # Advances the month view forward by one month.
    def show_next_month : self
      LibQt6.qt6cr_calendar_widget_show_next_month(to_unsafe)
      self
    end

    # Moves the month view back by one month.
    def show_previous_month : self
      LibQt6.qt6cr_calendar_widget_show_previous_month(to_unsafe)
      self
    end

    # Advances the month view forward by one year.
    def show_next_year : self
      LibQt6.qt6cr_calendar_widget_show_next_year(to_unsafe)
      self
    end

    # Moves the month view back by one year.
    def show_previous_year : self
      LibQt6.qt6cr_calendar_widget_show_previous_year(to_unsafe)
      self
    end

    # Scrolls the view so the selected date is visible.
    def show_selected_date : self
      LibQt6.qt6cr_calendar_widget_show_selected_date(to_unsafe)
      self
    end

    # Scrolls the view to today's date.
    def show_today : self
      LibQt6.qt6cr_calendar_widget_show_today(to_unsafe)
      self
    end

    # Registers a block to run when the selection changes.
    def on_selection_changed(&block : ->) : self
      @selection_changed.connect { block.call }
      self
    end

    # Registers a block to run when a date is clicked.
    def on_clicked(&block : QDate ->) : self
      @clicked.connect { |date| block.call(date) }
      self
    end

    # Registers a block to run when a date is activated.
    def on_activated(&block : QDate ->) : self
      @activated.connect { |date| block.call(date) }
      self
    end

    # Registers a block to run when the visible year/month page changes.
    def on_current_page_changed(&block : Int32, Int32 ->) : self
      @current_page_changed.connect { |year, month| block.call(year, month) }
      self
    end

    protected def emit_selection_changed : Nil
      @selection_changed.emit
    end

    protected def emit_clicked(handle : LibQt6::Handle) : Nil
      @clicked.emit(QDate.wrap(handle, true))
    end

    protected def emit_activated(handle : LibQt6::Handle) : Nil
      @activated.emit(QDate.wrap(handle, true))
    end

    protected def emit_current_page_changed(year : Int32, month : Int32) : Nil
      @current_page_changed.emit(year, month)
    end

    private def register_calendar_callbacks : Nil
      @selection_changed = Signal().new
      @clicked = Signal(QDate).new
      @activated = Signal(QDate).new
      @current_page_changed = Signal(Int32, Int32).new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_calendar_widget_on_selection_changed(to_unsafe, SELECTION_CHANGED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_calendar_widget_on_clicked(to_unsafe, CLICKED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_calendar_widget_on_activated(to_unsafe, ACTIVATED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_calendar_widget_on_current_page_changed(to_unsafe, CURRENT_PAGE_CHANGED_TRAMPOLINE, @callback_userdata)
    end

    private SELECTION_CHANGED_TRAMPOLINE = ->(userdata : Void*) do
      Box(CalendarWidget).unbox(userdata).emit_selection_changed
    end

    private CLICKED_TRAMPOLINE = ->(userdata : Void*, handle : Void*) do
      Box(CalendarWidget).unbox(userdata).emit_clicked(handle)
    end

    private ACTIVATED_TRAMPOLINE = ->(userdata : Void*, handle : Void*) do
      Box(CalendarWidget).unbox(userdata).emit_activated(handle)
    end

    private CURRENT_PAGE_CHANGED_TRAMPOLINE = ->(userdata : Void*, year : Int32, month : Int32) do
      Box(CalendarWidget).unbox(userdata).emit_current_page_changed(year, month)
    end
  end
end
