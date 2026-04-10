module Qt6
  # Wraps the process-wide Qt application object.
  class Application
    @argv_storage : Array(String)
    @argv : Array(UInt8*)
    @handle : LibQt6::Handle
    @destroyed = false

    # Creates a new Qt application wrapper using the provided command-line
    # arguments.
    def initialize(args : Array(String))
      @argv_storage = args.empty? ? ["crystal-qt6"] : args
      @argv = @argv_storage.map(&.to_unsafe)
      @argv << Pointer(UInt8).null
      @handle = LibQt6.qt6cr_application_create(@argv_storage.size, @argv.to_unsafe)
    end

    # Enters the Qt event loop and blocks until the application exits.
    def run : Int32
      LibQt6.qt6cr_application_exec(@handle)
    end

    # Processes any pending Qt events without entering the main loop.
    def process_events : Nil
      LibQt6.qt6cr_application_process_events(@handle)
    end

    # Requests that the Qt event loop exit.
    def quit : Nil
      LibQt6.qt6cr_application_quit(@handle)
    end

    # Returns the process-wide clipboard wrapper.
    def clipboard : Clipboard
      Clipboard.wrap(LibQt6.qt6cr_application_clipboard(@handle))
    end

    # Destroys the underlying Qt application if it is still active.
    def shutdown : Nil
      return if @destroyed

      LibQt6.qt6cr_application_destroy(@handle)
      @destroyed = true
    end
  end
end
