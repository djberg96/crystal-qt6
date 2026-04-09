require "./qt6/native"

module Qt6
  VERSION = "0.1.0"
  @@application : Application?
  @@tracked_objects = [] of QObject
  @@shutdown_registered = false

  class Error < Exception
  end

  record PointF, x : Float64, y : Float64 do
    def self.from_native(value : LibQt6::PointFValue) : self
      new(value.x, value.y)
    end

    def to_native : LibQt6::PointFValue
      LibQt6::PointFValue.new(x: x, y: y)
    end
  end

  record Size, width : Int32, height : Int32 do
    def self.from_native(value : LibQt6::SizeValue) : self
      new(value.width, value.height)
    end
  end

  record RectF, x : Float64, y : Float64, width : Float64, height : Float64 do
    def self.from_native(value : LibQt6::RectFValue) : self
      new(value.x, value.y, value.width, value.height)
    end
  end

  record PaintEvent, rect : RectF
  record ResizeEvent, old_size : Size, size : Size
  record MouseEvent, position : PointF, button : Int32, buttons : Int32, modifiers : Int32 do
    def self.from_native(value : LibQt6::MouseEventValue) : self
      new(PointF.from_native(value.position), value.button, value.buttons, value.modifiers)
    end
  end

  record WheelEvent, position : PointF, pixel_delta : PointF, angle_delta : PointF, buttons : Int32, modifiers : Int32 do
    def self.from_native(value : LibQt6::WheelEventValue) : self
      new(
        PointF.from_native(value.position),
        PointF.from_native(value.pixel_delta),
        PointF.from_native(value.angle_delta),
        value.buttons,
        value.modifiers
      )
    end
  end

  record KeyEvent, key : Int32, modifiers : Int32, auto_repeat : Bool, count : Int32 do
    def self.from_native(value : LibQt6::KeyEventValue) : self
      new(value.key, value.modifiers, value.auto_repeat, value.count)
    end
  end

  class Signal(*T)
    def initialize
      @handlers = [] of Proc(*T, Nil)
    end

    def connect(&block : *T ->) : self
      @handlers << block
      self
    end

    def emit(*args : *T) : Nil
      @handlers.each do |handler|
        handler.call(*args)
      end
    end
  end

  def self.application(args : Enumerable(String) = ARGV)
    register_shutdown_hook
    @@application ||= Application.new(args.to_a)
  end

  def self.shutdown : Nil
    tracked_objects = @@tracked_objects.dup
    tracked_objects.reverse_each(&.release)
    @@tracked_objects.clear

    application = @@application
    return unless application

    application.shutdown
    @@application = nil
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

  def self.track_object(object : QObject) : Nil
    @@tracked_objects << object
  end

  def self.untrack_object(object : QObject) : Nil
    @@tracked_objects.delete(object)
  end

  private def self.register_shutdown_hook : Nil
    return if @@shutdown_registered

    at_exit { Qt6.shutdown }
    @@shutdown_registered = true
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

    def shutdown : Nil
      return if @destroyed

      LibQt6.qt6cr_application_destroy(@handle)
      @destroyed = true
    end
  end

  class QObject
    getter to_unsafe : LibQt6::Handle
    @destroyed_signal : Signal() = Signal().new
    @owned : Bool = false
    @destroyed = false
    @destroyed_userdata : LibQt6::Handle = Pointer(Void).null

    protected def initialize(@to_unsafe : LibQt6::Handle, @owned : Bool)
      @destroyed_signal = Signal().new
      @destroyed_userdata = Box.box(self.as(QObject))
      LibQt6.qt6cr_object_on_destroyed(@to_unsafe, OBJECT_DESTROYED_TRAMPOLINE, @destroyed_userdata)
      Qt6.track_object(self) if @owned
    end

    def release : Nil
      return if @destroyed || !@owned

      LibQt6.qt6cr_object_destroy(@to_unsafe)
    end

    def destroyed? : Bool
      @destroyed
    end

    def destroyed : Signal()
      @destroyed_signal
    end

    protected def mark_destroyed_from_qt : Nil
      return if @destroyed

      @destroyed = true
      Qt6.untrack_object(self)
      @destroyed_signal.emit
    end

    private OBJECT_DESTROYED_TRAMPOLINE = ->(userdata : Void*) do
      Box(QObject).unbox(userdata).mark_destroyed_from_qt
    end
  end

  class Widget < QObject

    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_widget_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
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

    def size : Size
      Size.from_native(LibQt6.qt6cr_widget_size(@to_unsafe))
    end

    def rect : RectF
      RectF.from_native(LibQt6.qt6cr_widget_rect(@to_unsafe))
    end

    def update : self
      LibQt6.qt6cr_widget_update(@to_unsafe)
      self
    end

    def vbox(&block : VBoxLayout ->)
      layout = VBoxLayout.new(self)
      yield layout
      layout
    end

    def adopt_by_parent! : Nil
      Qt6.untrack_object(self) if @owned
      @owned = false
    end
  end

  class EventWidget < Widget
    @painted : Signal(PaintEvent) = Signal(PaintEvent).new
    @resized : Signal(ResizeEvent) = Signal(ResizeEvent).new
    @mouse_pressed : Signal(MouseEvent) = Signal(MouseEvent).new
    @mouse_moved : Signal(MouseEvent) = Signal(MouseEvent).new
    @mouse_released : Signal(MouseEvent) = Signal(MouseEvent).new
    @wheel_turned : Signal(WheelEvent) = Signal(WheelEvent).new
    @key_pressed : Signal(KeyEvent) = Signal(KeyEvent).new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null
    getter painted : Signal(PaintEvent)
    getter resized : Signal(ResizeEvent)
    getter mouse_pressed : Signal(MouseEvent)
    getter mouse_moved : Signal(MouseEvent)
    getter mouse_released : Signal(MouseEvent)
    getter wheel_turned : Signal(WheelEvent)
    getter key_pressed : Signal(KeyEvent)

    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_event_widget_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      @painted = Signal(PaintEvent).new
      @resized = Signal(ResizeEvent).new
      @mouse_pressed = Signal(MouseEvent).new
      @mouse_moved = Signal(MouseEvent).new
      @mouse_released = Signal(MouseEvent).new
      @wheel_turned = Signal(WheelEvent).new
      @key_pressed = Signal(KeyEvent).new
      @callback_userdata = Box.box(self)

      LibQt6.qt6cr_event_widget_on_paint(to_unsafe, PAINT_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_event_widget_on_resize(to_unsafe, RESIZE_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_event_widget_on_mouse_press(to_unsafe, MOUSE_PRESS_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_event_widget_on_mouse_move(to_unsafe, MOUSE_MOVE_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_event_widget_on_mouse_release(to_unsafe, MOUSE_RELEASE_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_event_widget_on_wheel(to_unsafe, WHEEL_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_event_widget_on_key_press(to_unsafe, KEY_PRESS_TRAMPOLINE, @callback_userdata)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def on_paint(&block : PaintEvent ->) : self
      @painted.connect { |event| block.call(event) }
      self
    end

    def on_resize(&block : ResizeEvent ->) : self
      @resized.connect { |event| block.call(event) }
      self
    end

    def on_mouse_press(&block : MouseEvent ->) : self
      @mouse_pressed.connect { |event| block.call(event) }
      self
    end

    def on_mouse_move(&block : MouseEvent ->) : self
      @mouse_moved.connect { |event| block.call(event) }
      self
    end

    def on_mouse_release(&block : MouseEvent ->) : self
      @mouse_released.connect { |event| block.call(event) }
      self
    end

    def on_wheel(&block : WheelEvent ->) : self
      @wheel_turned.connect { |event| block.call(event) }
      self
    end

    def on_key_press(&block : KeyEvent ->) : self
      @key_pressed.connect { |event| block.call(event) }
      self
    end

    def repaint_now : self
      LibQt6.qt6cr_event_widget_repaint(to_unsafe)
      self
    end

    def simulate_mouse_press(position : PointF, button : Int32 = 1, buttons : Int32 = button, modifiers : Int32 = 0) : self
      LibQt6.qt6cr_event_widget_send_mouse_press(to_unsafe, position.to_native, button, buttons, modifiers)
      self
    end

    def simulate_mouse_move(position : PointF, button : Int32 = 0, buttons : Int32 = 0, modifiers : Int32 = 0) : self
      LibQt6.qt6cr_event_widget_send_mouse_move(to_unsafe, position.to_native, button, buttons, modifiers)
      self
    end

    def simulate_mouse_release(position : PointF, button : Int32 = 1, buttons : Int32 = 0, modifiers : Int32 = 0) : self
      LibQt6.qt6cr_event_widget_send_mouse_release(to_unsafe, position.to_native, button, buttons, modifiers)
      self
    end

    def simulate_wheel(position : PointF, pixel_delta : PointF = PointF.new(0.0, 0.0), angle_delta : PointF = PointF.new(0.0, 120.0), buttons : Int32 = 0, modifiers : Int32 = 0) : self
      LibQt6.qt6cr_event_widget_send_wheel(to_unsafe, position.to_native, pixel_delta.to_native, angle_delta.to_native, buttons, modifiers)
      self
    end

    def simulate_key_press(key : Int32, modifiers : Int32 = 0, auto_repeat : Bool = false, count : Int32 = 1) : self
      LibQt6.qt6cr_event_widget_send_key_press(to_unsafe, key, modifiers, auto_repeat, count)
      self
    end

    protected def emit_paint(event : PaintEvent) : Nil
      @painted.emit(event)
    end

    protected def emit_resize(event : ResizeEvent) : Nil
      @resized.emit(event)
    end

    protected def emit_mouse_press(event : MouseEvent) : Nil
      @mouse_pressed.emit(event)
    end

    protected def emit_mouse_move(event : MouseEvent) : Nil
      @mouse_moved.emit(event)
    end

    protected def emit_mouse_release(event : MouseEvent) : Nil
      @mouse_released.emit(event)
    end

    protected def emit_wheel(event : WheelEvent) : Nil
      @wheel_turned.emit(event)
    end

    protected def emit_key_press(event : KeyEvent) : Nil
      @key_pressed.emit(event)
    end

    private PAINT_TRAMPOLINE = ->(userdata : Void*, rect : LibQt6::RectFValue) do
      Box(EventWidget).unbox(userdata).emit_paint(PaintEvent.new(RectF.from_native(rect)))
    end

    private RESIZE_TRAMPOLINE = ->(userdata : Void*, old_size : LibQt6::SizeValue, new_size : LibQt6::SizeValue) do
      Box(EventWidget).unbox(userdata).emit_resize(ResizeEvent.new(Size.from_native(old_size), Size.from_native(new_size)))
    end

    private MOUSE_PRESS_TRAMPOLINE = ->(userdata : Void*, event_value : LibQt6::MouseEventValue) do
      Box(EventWidget).unbox(userdata).emit_mouse_press(MouseEvent.from_native(event_value))
    end

    private MOUSE_MOVE_TRAMPOLINE = ->(userdata : Void*, event_value : LibQt6::MouseEventValue) do
      Box(EventWidget).unbox(userdata).emit_mouse_move(MouseEvent.from_native(event_value))
    end

    private MOUSE_RELEASE_TRAMPOLINE = ->(userdata : Void*, event_value : LibQt6::MouseEventValue) do
      Box(EventWidget).unbox(userdata).emit_mouse_release(MouseEvent.from_native(event_value))
    end

    private WHEEL_TRAMPOLINE = ->(userdata : Void*, event_value : LibQt6::WheelEventValue) do
      Box(EventWidget).unbox(userdata).emit_wheel(WheelEvent.from_native(event_value))
    end

    private KEY_PRESS_TRAMPOLINE = ->(userdata : Void*, event_value : LibQt6::KeyEventValue) do
      Box(EventWidget).unbox(userdata).emit_key_press(KeyEvent.from_native(event_value))
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
    @clicked : Signal() = Signal().new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null
    getter clicked : Signal()

    def initialize(text : String = "", parent : Widget? = nil)
      super(LibQt6.qt6cr_push_button_create(parent.try(&.to_unsafe) || Pointer(Void).null, text.to_unsafe), parent.nil?)
      @clicked = Signal().new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_push_button_on_clicked(to_unsafe, CLICK_TRAMPOLINE, @callback_userdata)
    end

    def text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_push_button_text(to_unsafe))
    end

    def text=(value : String) : String
      LibQt6.qt6cr_push_button_set_text(to_unsafe, value.to_unsafe)
      value
    end

    def on_clicked(&block : ->) : self
      @clicked.connect { block.call }
      self
    end

    def click : self
      LibQt6.qt6cr_push_button_click(to_unsafe)
      self
    end

    protected def emit_clicked : Nil
      @clicked.emit
    end

    private CLICK_TRAMPOLINE = ->(userdata : Void*) do
      Box(PushButton).unbox(userdata).emit_clicked
    end
  end

  class QTimer < QObject
    @timeout : Signal() = Signal().new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null
    getter timeout : Signal()

    def initialize(parent : QObject? = nil)
      super(LibQt6.qt6cr_timer_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      @timeout = Signal().new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_timer_on_timeout(to_unsafe, TIMEOUT_TRAMPOLINE, @callback_userdata)
    end

    def interval : Int32
      LibQt6.qt6cr_timer_interval(to_unsafe)
    end

    def interval=(value : Int) : Int32
      LibQt6.qt6cr_timer_set_interval(to_unsafe, value)
      value.to_i
    end

    def single_shot? : Bool
      LibQt6.qt6cr_timer_is_single_shot(to_unsafe)
    end

    def single_shot=(value : Bool) : Bool
      LibQt6.qt6cr_timer_set_single_shot(to_unsafe, value)
      value
    end

    def active? : Bool
      LibQt6.qt6cr_timer_is_active(to_unsafe)
    end

    def start(interval : Int? = nil) : self
      self.interval = interval.not_nil! if interval
      LibQt6.qt6cr_timer_start(to_unsafe)
      self
    end

    def stop : self
      LibQt6.qt6cr_timer_stop(to_unsafe)
      self
    end

    def on_timeout(&block : ->) : self
      @timeout.connect { block.call }
      self
    end

    protected def emit_timeout : Nil
      @timeout.emit
    end

    private TIMEOUT_TRAMPOLINE = ->(userdata : Void*) do
      Box(QTimer).unbox(userdata).emit_timeout
    end
  end

  class VBoxLayout < QObject

    def initialize(parent : Widget)
      super(LibQt6.qt6cr_v_box_layout_create(parent.to_unsafe), false)
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
