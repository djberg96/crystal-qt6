module Qt6
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
end
