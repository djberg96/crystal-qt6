module Qt6
  # Wraps the process-wide Qt application object.
  class Application
    @argv_storage : Array(String)
    @argv : Array(UInt8*)
    @handle : LibQt6::Handle
    @pending_invocations : Array(DeferredInvocation)
    @pending_invocations_lock : Mutex
    @destroyed = false

    getter to_unsafe : LibQt6::Handle

    # Creates a new Qt application wrapper using the provided command-line
    # arguments.
    def initialize(args : Array(String))
      @argv_storage = args.empty? ? ["crystal-qt6"] : args
      @argv = @argv_storage.map(&.to_unsafe)
      @argv << Pointer(UInt8).null
      @pending_invocations = [] of DeferredInvocation
      @pending_invocations_lock = Mutex.new
      @handle = LibQt6.qt6cr_application_create(@argv_storage.size, @argv.to_unsafe)
      @to_unsafe = @handle
    end

    # Enters the Qt event loop and blocks until the application exits.
    def run : Int32
      LibQt6.qt6cr_application_exec(@handle)
    end

    # Processes any pending Qt events without entering the main loop.
    def process_events : Nil
      LibQt6.qt6cr_application_process_events(@handle)
    end

    # Schedules work to run later on the Qt event loop.
    def invoke_later(&block : ->) : Nil
      invocation = DeferredInvocation.new(self) { block.call }
      @pending_invocations_lock.synchronize do
        @pending_invocations << invocation
      end

      scheduled = LibQt6.qt6cr_application_invoke_later(@handle, INVOKE_LATER_TRAMPOLINE, invocation.userdata)
      unless scheduled
        remove_pending_invocation(invocation)
        invocation.clear_userdata
      end
    end

    # Requests that the Qt event loop exit.
    def quit : Nil
      LibQt6.qt6cr_application_quit(@handle)
    end

    # Returns the process-wide clipboard wrapper.
    def clipboard : Clipboard
      Clipboard.wrap(LibQt6.qt6cr_application_clipboard(@handle))
    end

    # Returns the current application name.
    def name : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_application_name(@handle))
    end

    # Sets the application name.
    def name=(value : String) : String
      LibQt6.qt6cr_application_set_name(@handle, value.to_unsafe)
      value
    end

    # Returns the current organization name.
    def organization_name : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_application_organization_name(@handle))
    end

    # Sets the organization name.
    def organization_name=(value : String) : String
      LibQt6.qt6cr_application_set_organization_name(@handle, value.to_unsafe)
      value
    end

    # Returns the current organization domain.
    def organization_domain : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_application_organization_domain(@handle))
    end

    # Sets the organization domain.
    def organization_domain=(value : String) : String
      LibQt6.qt6cr_application_set_organization_domain(@handle, value.to_unsafe)
      value
    end

    # Returns the application-wide style sheet.
    def style_sheet : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_application_style_sheet(@handle))
    end

    # Sets the application-wide style sheet.
    def style_sheet=(value : String) : String
      LibQt6.qt6cr_application_set_style_sheet(@handle, value.to_unsafe)
      value
    end

    # Returns the current application window icon.
    def window_icon : QIcon
      QIcon.wrap(LibQt6.qt6cr_application_window_icon(@handle), true)
    end

    # Sets the application window icon.
    def window_icon=(value : QIcon) : QIcon
      LibQt6.qt6cr_application_set_window_icon(@handle, value.to_unsafe)
      value
    end

    # Returns the application palette.
    def palette : QPalette
      QPalette.wrap(LibQt6.qt6cr_application_palette(@handle), true)
    end

    # Sets the application palette.
    def palette=(value : QPalette) : QPalette
      LibQt6.qt6cr_application_set_palette(@handle, value.to_unsafe)
      value
    end

    # Returns the application's current style.
    def style : Style?
      handle = LibQt6.qt6cr_application_style(@handle)
      handle.null? ? nil : Style.wrap(handle)
    end

    # Sets the application's current style.
    def style=(value : Style) : Style
      LibQt6.qt6cr_application_set_style(@handle, value.to_unsafe)
      value.adopt_by_parent!
      value
    end

    # Sets the application's current style by Qt style name.
    def set_style(name : String) : Style?
      handle = LibQt6.qt6cr_application_set_style_by_name(@handle, name.to_unsafe)
      handle.null? ? nil : Style.wrap(handle)
    end

    # Returns the cursor flash interval in milliseconds.
    def cursor_flash_time : Int32
      LibQt6.qt6cr_application_cursor_flash_time(@handle)
    end

    # Sets the cursor flash interval in milliseconds.
    def cursor_flash_time=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_application_set_cursor_flash_time(@handle, int_value)
      int_value
    end

    # Returns the double-click interval in milliseconds.
    def double_click_interval : Int32
      LibQt6.qt6cr_application_double_click_interval(@handle)
    end

    # Sets the double-click interval in milliseconds.
    def double_click_interval=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_application_set_double_click_interval(@handle, int_value)
      int_value
    end

    # Returns the keyboard input interval in milliseconds.
    def keyboard_input_interval : Int32
      LibQt6.qt6cr_application_keyboard_input_interval(@handle)
    end

    # Sets the keyboard input interval in milliseconds.
    def keyboard_input_interval=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_application_set_keyboard_input_interval(@handle, int_value)
      int_value
    end

    # Returns the number of lines scrolled per wheel step.
    def wheel_scroll_lines : Int32
      LibQt6.qt6cr_application_wheel_scroll_lines(@handle)
    end

    # Sets the number of lines scrolled per wheel step.
    def wheel_scroll_lines=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_application_set_wheel_scroll_lines(@handle, int_value)
      int_value
    end

    # Returns the drag start time in milliseconds.
    def start_drag_time : Int32
      LibQt6.qt6cr_application_start_drag_time(@handle)
    end

    # Sets the drag start time in milliseconds.
    def start_drag_time=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_application_set_start_drag_time(@handle, int_value)
      int_value
    end

    # Returns the drag start distance in pixels.
    def start_drag_distance : Int32
      LibQt6.qt6cr_application_start_drag_distance(@handle)
    end

    # Sets the drag start distance in pixels.
    def start_drag_distance=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_application_set_start_drag_distance(@handle, int_value)
      int_value
    end

    # Returns whether automatic SIP activation is enabled.
    def auto_sip_enabled? : Bool
      LibQt6.qt6cr_application_auto_sip_enabled(@handle)
    end

    # Enables or disables automatic SIP activation.
    def auto_sip_enabled=(value : Bool) : Bool
      LibQt6.qt6cr_application_set_auto_sip_enabled(@handle, value)
      value
    end

    # Returns the application's active top-level window, if any.
    def active_window : Widget?
      handle = LibQt6.qt6cr_application_active_window(@handle)
      handle.null? ? nil : Widget.wrap(handle)
    end

    # Returns the widget that currently owns keyboard focus, if any.
    def focus_widget : Widget?
      handle = LibQt6.qt6cr_application_focus_widget(@handle)
      handle.null? ? nil : Widget.wrap(handle)
    end

    # Requests that all top-level windows be closed.
    def close_all_windows : Nil
      LibQt6.qt6cr_application_close_all_windows(@handle)
    end

    # Destroys the underlying Qt application if it is still active.
    def shutdown : Nil
      return if @destroyed

      LibQt6.qt6cr_application_destroy(@handle)
      @destroyed = true
    end

    protected def remove_pending_invocation(invocation : DeferredInvocation) : Nil
      @pending_invocations_lock.synchronize do
        @pending_invocations.delete(invocation)
      end
    end

    private class DeferredInvocation
      @userdata : LibQt6::Handle = Pointer(Void).null

      def initialize(@app : Application, &@block : ->)
        @userdata = Box.box(self)
      end

      def userdata : LibQt6::Handle
        @userdata
      end

      def call : Nil
        begin
          @block.call
        ensure
          @app.remove_pending_invocation(self)
          clear_userdata
        end
      end

      def clear_userdata : Nil
        @userdata = Pointer(Void).null
      end
    end

    private INVOKE_LATER_TRAMPOLINE = ->(userdata : Void*) do
      Box(DeferredInvocation).unbox(userdata).call
    end
  end
end
