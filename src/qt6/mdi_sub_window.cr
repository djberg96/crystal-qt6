module Qt6
  # Wraps `QMdiSubWindow`.
  class MdiSubWindow < Widget
    @about_to_activate : Signal() = Signal().new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    getter about_to_activate : Signal()

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

    # Registers a block to run right before the subwindow activates.
    def on_about_to_activate(&block : ->) : self
      @about_to_activate.connect { block.call }
      self
    end

    protected def emit_about_to_activate : Nil
      @about_to_activate.emit
    end

    private def register_callbacks : Nil
      @about_to_activate = Signal().new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_mdi_sub_window_on_about_to_activate(to_unsafe, ABOUT_TO_ACTIVATE_TRAMPOLINE, @callback_userdata)
    end

    private ABOUT_TO_ACTIVATE_TRAMPOLINE = ->(userdata : Void*) do
      Box(MdiSubWindow).unbox(userdata).emit_about_to_activate
    end
  end
end
