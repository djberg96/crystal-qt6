require "./qt6/native"

module Qt6
  VERSION = "0.1.0"

  class Error < Exception
  end

  def self.application(args : Enumerable(String) = ARGV)
    @@application ||= Application.new(args.to_a)
  end

  def self.window(title : String, width : Int32 = 800, height : Int32 = 600, &)
    widget = Widget.new
    widget.window_title = title
    widget.resize(width, height)
    yield widget
    widget
  end

  def self.copy_and_release_string(pointer : UInt8*) : String
    return "" if pointer.null?

    value = String.new(pointer)
    LibQt6.qt6cr_string_free(pointer)
    value
  end

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

    def finalize
      return if @destroyed

      LibQt6.qt6cr_application_destroy(@handle)
      @destroyed = true
    end
  end

  class Widget
    getter to_unsafe : LibQt6::Handle
    @owned : Bool
    @destroyed = false

    def initialize(parent : Widget? = nil)
      @owned = parent.nil?
      @to_unsafe = LibQt6.qt6cr_widget_create(parent.try(&.to_unsafe) || Pointer(Void).null)
    end

    protected def initialize(@to_unsafe : LibQt6::Handle, @owned : Bool)
    end

    def window_title : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_widget_window_title(@to_unsafe))
    end

    def window_title=(value : String) : String
      LibQt6.qt6cr_widget_set_window_title(@to_unsafe, value.to_unsafe)
      value
    end

    def resize(width : Int, height : Int) : self
      LibQt6.qt6cr_widget_resize(@to_unsafe, width, height)
      self
    end

    def show : self
      LibQt6.qt6cr_widget_show(@to_unsafe)
      self
    end

    def close : self
      LibQt6.qt6cr_widget_close(@to_unsafe)
      self
    end

    def visible? : Bool
      LibQt6.qt6cr_widget_is_visible(@to_unsafe)
    end

    def vbox(&block : VBoxLayout ->)
      layout = VBoxLayout.new(self)
      yield layout
      layout
    end

    def release : Nil
      return if @destroyed || !@owned

      LibQt6.qt6cr_widget_destroy(@to_unsafe)
      @destroyed = true
    end

    def finalize
      release
    end

    def adopt_by_parent! : Nil
      @owned = false
    end
  end

  class Label < Widget
    def initialize(text : String = "", parent : Widget? = nil)
      super(LibQt6.qt6cr_label_create(parent.try(&.to_unsafe) || Pointer(Void).null, text.to_unsafe), parent.nil?)
    end

    def text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_label_text(to_unsafe))
    end

    def text=(value : String) : String
      LibQt6.qt6cr_label_set_text(to_unsafe, value.to_unsafe)
      value
    end
  end

  class PushButton < Widget
    @click_handlers = [] of Proc(Nil)

    def initialize(text : String = "", parent : Widget? = nil)
      super(LibQt6.qt6cr_push_button_create(parent.try(&.to_unsafe) || Pointer(Void).null, text.to_unsafe), parent.nil?)
    end

    def text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_push_button_text(to_unsafe))
    end

    def text=(value : String) : String
      LibQt6.qt6cr_push_button_set_text(to_unsafe, value.to_unsafe)
      value
    end

    def on_clicked(&block : ->) : self
      callback = -> { block.call }
      @click_handlers << callback
      LibQt6.qt6cr_push_button_on_clicked(to_unsafe, CLICK_TRAMPOLINE, Box.box(callback))
      self
    end

    def click : self
      LibQt6.qt6cr_push_button_click(to_unsafe)
      self
    end

    private CLICK_TRAMPOLINE = ->(userdata : Void*) do
      Box(Proc(Nil)).unbox(userdata).call
    end
  end

  class VBoxLayout
    getter to_unsafe : LibQt6::Handle

    def initialize(parent : Widget)
      @to_unsafe = LibQt6.qt6cr_v_box_layout_create(parent.to_unsafe)
    end

    def add(widget : Widget) : Widget
      LibQt6.qt6cr_v_box_layout_add_widget(@to_unsafe, widget.to_unsafe)
      widget.adopt_by_parent!
      widget
    end

    def <<(widget : Widget) : self
      add(widget)
      self
    end
  end
end
