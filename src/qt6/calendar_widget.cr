module Qt6
  # Wraps `QCalendarWidget`.
  class CalendarWidget < Widget
    @selection_changed : Signal() = Signal().new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    getter selection_changed : Signal()

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_calendar_widget_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      @selection_changed = Signal().new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_calendar_widget_on_selection_changed(to_unsafe, SELECTION_CHANGED_TRAMPOLINE, @callback_userdata)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      @selection_changed = Signal().new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_calendar_widget_on_selection_changed(to_unsafe, SELECTION_CHANGED_TRAMPOLINE, @callback_userdata)
    end

    def selected_date : QDate
      QDate.wrap(LibQt6.qt6cr_calendar_widget_selected_date(to_unsafe), true)
    end

    def selected_date=(value : QDate) : QDate
      LibQt6.qt6cr_calendar_widget_set_selected_date(to_unsafe, value.to_unsafe)
      value
    end

    def minimum_date : QDate
      QDate.wrap(LibQt6.qt6cr_calendar_widget_minimum_date(to_unsafe), true)
    end

    def minimum_date=(value : QDate) : QDate
      LibQt6.qt6cr_calendar_widget_set_minimum_date(to_unsafe, value.to_unsafe)
      value
    end

    def maximum_date : QDate
      QDate.wrap(LibQt6.qt6cr_calendar_widget_maximum_date(to_unsafe), true)
    end

    def maximum_date=(value : QDate) : QDate
      LibQt6.qt6cr_calendar_widget_set_maximum_date(to_unsafe, value.to_unsafe)
      value
    end

    def grid_visible? : Bool
      LibQt6.qt6cr_calendar_widget_grid_visible(to_unsafe)
    end

    def grid_visible=(value : Bool) : Bool
      LibQt6.qt6cr_calendar_widget_set_grid_visible(to_unsafe, value)
      value
    end

    def on_selection_changed(&block : ->) : self
      @selection_changed.connect { block.call }
      self
    end

    protected def emit_selection_changed : Nil
      @selection_changed.emit
    end

    private SELECTION_CHANGED_TRAMPOLINE = ->(userdata : Void*) do
      Box(CalendarWidget).unbox(userdata).emit_selection_changed
    end
  end
end
