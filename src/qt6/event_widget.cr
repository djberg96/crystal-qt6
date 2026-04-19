module Qt6
  # Lightweight copied event data for `EventWidget` callbacks that do not need
  # specialized payloads.
  record WidgetEvent, type : EventType

  # A custom widget bridge that surfaces paint, resize, mouse, wheel, key,
  # pointer-boundary, focus, and drop events into Crystal callbacks.
  class EventWidget < Widget
    @painted : Signal(PaintEvent) = Signal(PaintEvent).new
    @painted_with_painter : Signal(PaintEvent, QPainter) = Signal(PaintEvent, QPainter).new
    @resized : Signal(ResizeEvent) = Signal(ResizeEvent).new
    @mouse_pressed : Signal(MouseEvent) = Signal(MouseEvent).new
    @mouse_moved : Signal(MouseEvent) = Signal(MouseEvent).new
    @mouse_released : Signal(MouseEvent) = Signal(MouseEvent).new
    @mouse_double_clicked : Signal(MouseEvent) = Signal(MouseEvent).new
    @wheel_turned : Signal(WheelEvent) = Signal(WheelEvent).new
    @key_pressed : Signal(KeyEvent) = Signal(KeyEvent).new
    @key_released : Signal(KeyEvent) = Signal(KeyEvent).new
    @entered : Signal(WidgetEvent) = Signal(WidgetEvent).new
    @left : Signal(WidgetEvent) = Signal(WidgetEvent).new
    @focused_in : Signal(WidgetEvent) = Signal(WidgetEvent).new
    @focused_out : Signal(WidgetEvent) = Signal(WidgetEvent).new
    @drag_entered : Signal(DropEvent) = Signal(DropEvent).new
    @drag_moved : Signal(DropEvent) = Signal(DropEvent).new
    @dropped : Signal(DropEvent) = Signal(DropEvent).new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    # Signal emitted for paint events.
    getter painted : Signal(PaintEvent)
    # Signal emitted for paint events with a live `QPainter`.
    getter painted_with_painter : Signal(PaintEvent, QPainter)
    # Signal emitted for resize events.
    getter resized : Signal(ResizeEvent)
    # Signal emitted for mouse press events.
    getter mouse_pressed : Signal(MouseEvent)
    # Signal emitted for mouse move events.
    getter mouse_moved : Signal(MouseEvent)
    # Signal emitted for mouse release events.
    getter mouse_released : Signal(MouseEvent)
    # Signal emitted for mouse double-click events.
    getter mouse_double_clicked : Signal(MouseEvent)
    # Signal emitted for wheel events.
    getter wheel_turned : Signal(WheelEvent)
    # Signal emitted for key press events.
    getter key_pressed : Signal(KeyEvent)
    # Signal emitted for key release events.
    getter key_released : Signal(KeyEvent)
    # Signal emitted when the pointer enters the widget.
    getter entered : Signal(WidgetEvent)
    # Signal emitted when the pointer leaves the widget.
    getter left : Signal(WidgetEvent)
    # Signal emitted when the widget receives keyboard focus.
    getter focused_in : Signal(WidgetEvent)
    # Signal emitted when the widget loses keyboard focus.
    getter focused_out : Signal(WidgetEvent)
    # Signal emitted for drag-enter events.
    getter drag_entered : Signal(DropEvent)
    # Signal emitted for drag-move events.
    getter drag_moved : Signal(DropEvent)
    # Signal emitted for drop events.
    getter dropped : Signal(DropEvent)

    # Creates a custom event-enabled widget.
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_event_widget_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      @painted = Signal(PaintEvent).new
      @painted_with_painter = Signal(PaintEvent, QPainter).new
      @resized = Signal(ResizeEvent).new
      @mouse_pressed = Signal(MouseEvent).new
      @mouse_moved = Signal(MouseEvent).new
      @mouse_released = Signal(MouseEvent).new
      @mouse_double_clicked = Signal(MouseEvent).new
      @wheel_turned = Signal(WheelEvent).new
      @key_pressed = Signal(KeyEvent).new
      @key_released = Signal(KeyEvent).new
      @entered = Signal(WidgetEvent).new
      @left = Signal(WidgetEvent).new
      @focused_in = Signal(WidgetEvent).new
      @focused_out = Signal(WidgetEvent).new
      @drag_entered = Signal(DropEvent).new
      @drag_moved = Signal(DropEvent).new
      @dropped = Signal(DropEvent).new
      @callback_userdata = Box.box(self)

      LibQt6.qt6cr_event_widget_on_paint(to_unsafe, PAINT_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_event_widget_on_paint_with_painter(to_unsafe, PAINT_WITH_PAINTER_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_event_widget_on_resize(to_unsafe, RESIZE_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_event_widget_on_mouse_press(to_unsafe, MOUSE_PRESS_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_event_widget_on_mouse_move(to_unsafe, MOUSE_MOVE_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_event_widget_on_mouse_release(to_unsafe, MOUSE_RELEASE_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_event_widget_on_mouse_double_click(to_unsafe, MOUSE_DOUBLE_CLICK_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_event_widget_on_wheel(to_unsafe, WHEEL_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_event_widget_on_key_press(to_unsafe, KEY_PRESS_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_event_widget_on_key_release(to_unsafe, KEY_RELEASE_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_event_widget_on_enter(to_unsafe, ENTER_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_event_widget_on_leave(to_unsafe, LEAVE_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_event_widget_on_focus_in(to_unsafe, FOCUS_IN_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_event_widget_on_focus_out(to_unsafe, FOCUS_OUT_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_event_widget_on_drag_enter(to_unsafe, DRAG_ENTER_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_event_widget_on_drag_move(to_unsafe, DRAG_MOVE_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_event_widget_on_drop(to_unsafe, DROP_TRAMPOLINE, @callback_userdata)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Registers a block for paint events.
    def on_paint(&block : PaintEvent ->) : self
      @painted.connect { |event| block.call(event) }
      self
    end

    # Registers a block for paint events that receives a live painter valid only
    # for the duration of the callback.
    def on_paint_with_painter(&block : PaintEvent, QPainter ->) : self
      @painted_with_painter.connect { |event, painter| block.call(event, painter) }
      self
    end

    # Registers a block for resize events.
    def on_resize(&block : ResizeEvent ->) : self
      @resized.connect { |event| block.call(event) }
      self
    end

    # Registers a block for mouse press events.
    def on_mouse_press(&block : MouseEvent ->) : self
      @mouse_pressed.connect { |event| block.call(event) }
      self
    end

    # Registers a block for mouse move events.
    def on_mouse_move(&block : MouseEvent ->) : self
      @mouse_moved.connect { |event| block.call(event) }
      self
    end

    # Registers a block for mouse release events.
    def on_mouse_release(&block : MouseEvent ->) : self
      @mouse_released.connect { |event| block.call(event) }
      self
    end

    # Registers a block for mouse double-click events.
    def on_mouse_double_click(&block : MouseEvent ->) : self
      @mouse_double_clicked.connect { |event| block.call(event) }
      self
    end

    # Registers a block for wheel events.
    def on_wheel(&block : WheelEvent ->) : self
      @wheel_turned.connect { |event| block.call(event) }
      self
    end

    # Registers a block for key press events.
    def on_key_press(&block : KeyEvent ->) : self
      @key_pressed.connect { |event| block.call(event) }
      self
    end

    # Registers a block for key release events.
    def on_key_release(&block : KeyEvent ->) : self
      @key_released.connect { |event| block.call(event) }
      self
    end

    # Registers a block for pointer-enter events.
    def on_enter(&block : WidgetEvent ->) : self
      @entered.connect { |event| block.call(event) }
      self
    end

    # Registers a block for pointer-leave events.
    def on_leave(&block : WidgetEvent ->) : self
      @left.connect { |event| block.call(event) }
      self
    end

    # Registers a block for focus-in events.
    def on_focus_in(&block : WidgetEvent ->) : self
      @focused_in.connect { |event| block.call(event) }
      self
    end

    # Registers a block for focus-out events.
    def on_focus_out(&block : WidgetEvent ->) : self
      @focused_out.connect { |event| block.call(event) }
      self
    end

    # Registers a block for drag-enter events.
    def on_drag_enter(&block : DropEvent ->) : self
      @drag_entered.connect { |event| block.call(event) }
      self
    end

    # Registers a block for drag-move events.
    def on_drag_move(&block : DropEvent ->) : self
      @drag_moved.connect { |event| block.call(event) }
      self
    end

    # Registers a block for drop events.
    def on_drop(&block : DropEvent ->) : self
      @dropped.connect { |event| block.call(event) }
      self
    end

    # Forces an immediate repaint of the widget.
    def repaint_now : self
      LibQt6.qt6cr_event_widget_repaint(to_unsafe)
      self
    end

    # Sends a synthetic mouse-press event to the widget.
    def simulate_mouse_press(position : PointF, button : Int32 = 1, buttons : Int32 = button, modifiers : Int32 = 0) : self
      LibQt6.qt6cr_event_widget_send_mouse_press(to_unsafe, position.to_native, button, buttons, modifiers)
      self
    end

    # Sends a synthetic mouse-move event to the widget.
    def simulate_mouse_move(position : PointF, button : Int32 = 0, buttons : Int32 = 0, modifiers : Int32 = 0) : self
      LibQt6.qt6cr_event_widget_send_mouse_move(to_unsafe, position.to_native, button, buttons, modifiers)
      self
    end

    # Sends a synthetic mouse-release event to the widget.
    def simulate_mouse_release(position : PointF, button : Int32 = 1, buttons : Int32 = 0, modifiers : Int32 = 0) : self
      LibQt6.qt6cr_event_widget_send_mouse_release(to_unsafe, position.to_native, button, buttons, modifiers)
      self
    end

    # Sends a synthetic mouse double-click event to the widget.
    def simulate_mouse_double_click(position : PointF, button : Int32 = 1, buttons : Int32 = button, modifiers : Int32 = 0) : self
      LibQt6.qt6cr_event_widget_send_mouse_double_click(to_unsafe, position.to_native, button, buttons, modifiers)
      self
    end

    # Sends a synthetic wheel event to the widget.
    def simulate_wheel(position : PointF, pixel_delta : PointF = PointF.new(0.0, 0.0), angle_delta : PointF = PointF.new(0.0, 120.0), buttons : Int32 = 0, modifiers : Int32 = 0) : self
      LibQt6.qt6cr_event_widget_send_wheel(to_unsafe, position.to_native, pixel_delta.to_native, angle_delta.to_native, buttons, modifiers)
      self
    end

    # Sends a synthetic key-press event to the widget.
    def simulate_key_press(key : Int32, modifiers : Int32 = 0, auto_repeat : Bool = false, count : Int32 = 1) : self
      LibQt6.qt6cr_event_widget_send_key_press(to_unsafe, key, modifiers, auto_repeat, count)
      self
    end

    # Sends a synthetic key-release event to the widget.
    def simulate_key_release(key : Int32, modifiers : Int32 = 0, auto_repeat : Bool = false, count : Int32 = 1) : self
      LibQt6.qt6cr_event_widget_send_key_release(to_unsafe, key, modifiers, auto_repeat, count)
      self
    end

    # Sends a synthetic pointer-enter event to the widget.
    def simulate_enter(position : PointF = PointF.new(0.0, 0.0)) : self
      LibQt6.qt6cr_event_widget_send_enter(to_unsafe, position.to_native)
      self
    end

    # Sends a synthetic pointer-leave event to the widget.
    def simulate_leave : self
      LibQt6.qt6cr_event_widget_send_leave(to_unsafe)
      self
    end

    # Sends a synthetic focus-in event to the widget.
    def simulate_focus_in : self
      LibQt6.qt6cr_event_widget_send_focus_in(to_unsafe)
      self
    end

    # Sends a synthetic focus-out event to the widget.
    def simulate_focus_out : self
      LibQt6.qt6cr_event_widget_send_focus_out(to_unsafe)
      self
    end

    # Sends a synthetic drag-enter event carrying text.
    def simulate_drag_enter_text(position : PointF, text : String, buttons : Int32 = 1, modifiers : Int32 = 0) : self
      LibQt6.qt6cr_event_widget_send_drag_enter_text(to_unsafe, position.to_native, text.to_unsafe, buttons, modifiers)
      self
    end

    # Sends a synthetic drag-move event carrying text.
    def simulate_drag_move_text(position : PointF, text : String, buttons : Int32 = 1, modifiers : Int32 = 0) : self
      LibQt6.qt6cr_event_widget_send_drag_move_text(to_unsafe, position.to_native, text.to_unsafe, buttons, modifiers)
      self
    end

    # Sends a synthetic drop event carrying text.
    def simulate_drop_text(position : PointF, text : String, buttons : Int32 = 1, modifiers : Int32 = 0) : self
      LibQt6.qt6cr_event_widget_send_drop_text(to_unsafe, position.to_native, text.to_unsafe, buttons, modifiers)
      self
    end

    protected def emit_paint(event : PaintEvent) : Nil
      @painted.emit(event)
    end

    protected def emit_paint_with_painter(event : PaintEvent, painter : QPainter) : Nil
      @painted_with_painter.emit(event, painter)
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

    protected def emit_mouse_double_click(event : MouseEvent) : Nil
      @mouse_double_clicked.emit(event)
    end

    protected def emit_wheel(event : WheelEvent) : Nil
      @wheel_turned.emit(event)
    end

    protected def emit_key_press(event : KeyEvent) : Nil
      @key_pressed.emit(event)
    end

    protected def emit_key_release(event : KeyEvent) : Nil
      @key_released.emit(event)
    end

    protected def emit_enter : Nil
      @entered.emit(WidgetEvent.new(EventType::Enter))
    end

    protected def emit_leave : Nil
      @left.emit(WidgetEvent.new(EventType::Leave))
    end

    protected def emit_focus_in : Nil
      @focused_in.emit(WidgetEvent.new(EventType::FocusIn))
    end

    protected def emit_focus_out : Nil
      @focused_out.emit(WidgetEvent.new(EventType::FocusOut))
    end

    protected def emit_drag_enter(event : DropEvent) : Nil
      @drag_entered.emit(event)
    end

    protected def emit_drag_move(event : DropEvent) : Nil
      @drag_moved.emit(event)
    end

    protected def emit_drop(event : DropEvent) : Nil
      @dropped.emit(event)
    end

    private PAINT_TRAMPOLINE = ->(userdata : Void*, rect : LibQt6::RectFValue) do
      Box(EventWidget).unbox(userdata).emit_paint(PaintEvent.new(RectF.from_native(rect)))
    end

    private PAINT_WITH_PAINTER_TRAMPOLINE = ->(userdata : Void*, painter_handle : Void*, rect : LibQt6::RectFValue) do
      widget = Box(EventWidget).unbox(userdata)
      widget.emit_paint_with_painter(PaintEvent.new(RectF.from_native(rect)), QPainter.wrap(painter_handle))
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

    private MOUSE_DOUBLE_CLICK_TRAMPOLINE = ->(userdata : Void*, event_value : LibQt6::MouseEventValue) do
      Box(EventWidget).unbox(userdata).emit_mouse_double_click(MouseEvent.from_native(event_value))
    end

    private WHEEL_TRAMPOLINE = ->(userdata : Void*, event_value : LibQt6::WheelEventValue) do
      Box(EventWidget).unbox(userdata).emit_wheel(WheelEvent.from_native(event_value))
    end

    private KEY_PRESS_TRAMPOLINE = ->(userdata : Void*, event_value : LibQt6::KeyEventValue) do
      Box(EventWidget).unbox(userdata).emit_key_press(KeyEvent.from_native(event_value))
    end

    private KEY_RELEASE_TRAMPOLINE = ->(userdata : Void*, event_value : LibQt6::KeyEventValue) do
      Box(EventWidget).unbox(userdata).emit_key_release(KeyEvent.from_native(event_value))
    end

    private ENTER_TRAMPOLINE = ->(userdata : Void*) do
      Box(EventWidget).unbox(userdata).emit_enter
    end

    private LEAVE_TRAMPOLINE = ->(userdata : Void*) do
      Box(EventWidget).unbox(userdata).emit_leave
    end

    private FOCUS_IN_TRAMPOLINE = ->(userdata : Void*) do
      Box(EventWidget).unbox(userdata).emit_focus_in
    end

    private FOCUS_OUT_TRAMPOLINE = ->(userdata : Void*) do
      Box(EventWidget).unbox(userdata).emit_focus_out
    end

    private DRAG_ENTER_TRAMPOLINE = ->(userdata : Void*, event_handle : Void*) do
      Box(EventWidget).unbox(userdata).emit_drag_enter(DropEvent.new(event_handle))
    end

    private DRAG_MOVE_TRAMPOLINE = ->(userdata : Void*, event_handle : Void*) do
      Box(EventWidget).unbox(userdata).emit_drag_move(DropEvent.new(event_handle))
    end

    private DROP_TRAMPOLINE = ->(userdata : Void*, event_handle : Void*) do
      Box(EventWidget).unbox(userdata).emit_drop(DropEvent.new(event_handle))
    end
  end
end
