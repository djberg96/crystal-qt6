module Qt6
  # Wraps `QMdiSubWindow`.
  class MdiSubWindow < Widget
    @about_to_activate : Signal() = Signal().new
    @window_state_changed : Signal(WindowState, WindowState) = Signal(WindowState, WindowState).new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    getter about_to_activate : Signal()
    getter window_state_changed : Signal(WindowState, WindowState)

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates an MDI subwindow with an optional parent.
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_mdi_sub_window_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      register_callbacks
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      register_callbacks
    end

    # Returns the hosted document widget, if present.
    def widget : Widget?
      handle = LibQt6.qt6cr_mdi_sub_window_widget(to_unsafe)
      handle.null? ? nil : Widget.wrap(handle)
    end

    # Sets or clears the hosted document widget.
    def widget=(value : Widget?) : Widget?
      LibQt6.qt6cr_mdi_sub_window_set_widget(to_unsafe, value.try(&.to_unsafe) || Pointer(Void).null)
      value.try(&.adopt_by_parent!)
      value
    end

    # Returns the system menu used by the subwindow, if any.
    def system_menu : Menu?
      handle = LibQt6.qt6cr_mdi_sub_window_system_menu(to_unsafe)
      handle.null? ? nil : Menu.wrap(handle)
    end

    # Sets or clears the system menu.
    def system_menu=(value : Menu?) : Menu?
      LibQt6.qt6cr_mdi_sub_window_set_system_menu(to_unsafe, value.try(&.to_unsafe) || Pointer(Void).null)
      value.try(&.adopt_by_parent!)
      value
    end

    # Returns the parent MDI area, if attached.
    def mdi_area : MdiArea?
      handle = LibQt6.qt6cr_mdi_sub_window_mdi_area(to_unsafe)
      handle.null? ? nil : MdiArea.wrap(handle)
    end

    # Returns `true` when the subwindow is shaded.
    def shaded? : Bool
      LibQt6.qt6cr_mdi_sub_window_is_shaded(to_unsafe)
    end

    # Enables or disables a single subwindow option.
    def set_option(option : MdiSubWindowOption, value : Bool = true) : Bool
      LibQt6.qt6cr_mdi_sub_window_set_option(to_unsafe, option.value, value)
      value
    end

    # Returns `true` when the option is enabled.
    def option?(option : MdiSubWindowOption) : Bool
      LibQt6.qt6cr_mdi_sub_window_test_option(to_unsafe, option.value)
    end

    # Returns the keyboard single-step distance.
    def keyboard_single_step : Int32
      LibQt6.qt6cr_mdi_sub_window_keyboard_single_step(to_unsafe)
    end

    # Sets the keyboard single-step distance and returns it.
    def keyboard_single_step=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_mdi_sub_window_set_keyboard_single_step(to_unsafe, int_value)
      int_value
    end

    # Returns the keyboard page-step distance.
    def keyboard_page_step : Int32
      LibQt6.qt6cr_mdi_sub_window_keyboard_page_step(to_unsafe)
    end

    # Sets the keyboard page-step distance and returns it.
    def keyboard_page_step=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_mdi_sub_window_set_keyboard_page_step(to_unsafe, int_value)
      int_value
    end

    # Shows the shaded representation where supported by Qt.
    def show_shaded : self
      LibQt6.qt6cr_mdi_sub_window_show_shaded(to_unsafe)
      self
    end

    # Shows the subwindow's system menu.
    def show_system_menu : self
      LibQt6.qt6cr_mdi_sub_window_show_system_menu(to_unsafe)
      self
    end

    # Registers a block to run right before the subwindow activates.
    def on_about_to_activate(&block : ->) : self
      @about_to_activate.connect { block.call }
      self
    end

    # Registers a block to run when the window state changes.
    def on_window_state_changed(&block : WindowState, WindowState ->) : self
      @window_state_changed.connect { |old_state, new_state| block.call(old_state, new_state) }
      self
    end

    # Qt-style alias for `widget=`.
    def set_widget(value : Widget?) : self
      self.widget = value
      self
    end

    # Qt-style alias for `system_menu=`.
    def set_system_menu(value : Menu?) : self
      self.system_menu = value
      self
    end

    # Qt-style alias for `keyboard_single_step=`.
    def set_keyboard_single_step(value : Int) : self
      self.keyboard_single_step = value
      self
    end

    # Qt-style alias for `keyboard_page_step=`.
    def set_keyboard_page_step(value : Int) : self
      self.keyboard_page_step = value
      self
    end

    protected def emit_about_to_activate : Nil
      @about_to_activate.emit
    end

    protected def emit_window_state_changed(old_state : WindowState, new_state : WindowState) : Nil
      @window_state_changed.emit(old_state, new_state)
    end

    private def register_callbacks : Nil
      @about_to_activate = Signal().new
      @window_state_changed = Signal(WindowState, WindowState).new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_mdi_sub_window_on_about_to_activate(to_unsafe, ABOUT_TO_ACTIVATE_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_mdi_sub_window_on_window_state_changed(to_unsafe, WINDOW_STATE_CHANGED_TRAMPOLINE, @callback_userdata)
    end

    private ABOUT_TO_ACTIVATE_TRAMPOLINE = ->(userdata : Void*) do
      Box(MdiSubWindow).unbox(userdata).emit_about_to_activate
    end

    private WINDOW_STATE_CHANGED_TRAMPOLINE = ->(userdata : Void*, old_state : Int32, new_state : Int32) do
      sub_window = Box(MdiSubWindow).unbox(userdata)
      sub_window.emit_window_state_changed(WindowState.from_value(old_state), WindowState.from_value(new_state))
    end
  end
end
