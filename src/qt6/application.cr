module Qt6
  class Application
    @argv_storage : Array(String)
    @argv : Array(UInt8*)
    @handle : LibQt6::Handle
    @destroyed = false

    def initialize(args : Array(String))
      @argv_storage = args.empty? ? ["crystal-qt6"] : args
      @argv = @argv_storage.map(&.to_unsafe)
      @argv << Pointer(UInt8).null
      @handle = LibQt6.qt6cr_application_create(@argv_storage.size, @argv.to_unsafe)
    end

    def run : Int32
      LibQt6.qt6cr_application_exec(@handle)
    end

    def process_events : Nil
      LibQt6.qt6cr_application_process_events(@handle)
    end

    def quit : Nil
      LibQt6.qt6cr_application_quit(@handle)
    end

    def shutdown : Nil
      return if @destroyed

      LibQt6.qt6cr_application_destroy(@handle)
      @destroyed = true
    end
  end
end
