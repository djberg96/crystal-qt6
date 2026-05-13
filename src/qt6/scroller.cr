module Qt6
  # Wraps `QScroller`.
  class Scroller < QObject
    @state_changed : Signal(ScrollerState) = Signal(ScrollerState).new
    @scroller_properties_changed : Signal(ScrollerProperties) = Signal(ScrollerProperties).new
    @state_changed_userdata : LibQt6::Handle = Pointer(Void).null
    @scroller_properties_changed_userdata : LibQt6::Handle = Pointer(Void).null

    getter state_changed : Signal(ScrollerState)
    getter scroller_properties_changed : Signal(ScrollerProperties)

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def self.has_scroller?(target : QObject) : Bool
      LibQt6.qt6cr_scroller_has_scroller(target.to_unsafe)
    end

    def self.scroller(target : QObject) : self
      wrap(LibQt6.qt6cr_scroller_for_target(target.to_unsafe))
    end

    def self.grab_gesture(target : QObject, gesture_type : ScrollerGestureType = ScrollerGestureType::TouchGesture) : Int32
      LibQt6.qt6cr_scroller_grab_gesture(target.to_unsafe, gesture_type.value)
    end

    def self.grabbed_gesture(target : QObject) : Int32
      LibQt6.qt6cr_scroller_grabbed_gesture(target.to_unsafe)
    end

    def self.ungrab_gesture(target : QObject) : Nil
      LibQt6.qt6cr_scroller_ungrab_gesture(target.to_unsafe)
    end

    def self.active_scrollers : Array(Scroller)
      Qt6.copy_and_release_handles(LibQt6.qt6cr_scroller_active_scrollers).map do |handle|
        wrap(handle)
      end
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      register_callbacks
    end

    def target : QObject?
      handle = LibQt6.qt6cr_scroller_target(to_unsafe)
      handle.null? ? nil : QObject.wrap(handle)
    end

    def state : ScrollerState
      ScrollerState.from_value(LibQt6.qt6cr_scroller_state(to_unsafe))
    end

    def handle_input(input : ScrollerInput, position : PointF, timestamp : Int64 = 0_i64) : Bool
      LibQt6.qt6cr_scroller_handle_input(to_unsafe, input.value, position.to_native, timestamp)
    end

    def stop : self
      LibQt6.qt6cr_scroller_stop(to_unsafe)
      self
    end

    def velocity : PointF
      PointF.from_native(LibQt6.qt6cr_scroller_velocity(to_unsafe))
    end

    def final_position : PointF
      PointF.from_native(LibQt6.qt6cr_scroller_final_position(to_unsafe))
    end

    def pixel_per_meter : PointF
      PointF.from_native(LibQt6.qt6cr_scroller_pixel_per_meter(to_unsafe))
    end

    def scroller_properties : ScrollerProperties
      ScrollerProperties.wrap(LibQt6.qt6cr_scroller_scroller_properties(to_unsafe), true)
    end

    def scroller_properties=(value : ScrollerProperties) : ScrollerProperties
      LibQt6.qt6cr_scroller_set_scroller_properties(to_unsafe, value.to_unsafe)
      value
    end

    def set_snap_positions_x(positions : Enumerable(Number)) : self
      values = positions.map(&.to_f64).to_a
      LibQt6.qt6cr_scroller_set_snap_positions_x_list(to_unsafe, values.to_unsafe, values.size.to_i32)
      self
    end

    def set_snap_positions_x(first : Number, interval : Number) : self
      LibQt6.qt6cr_scroller_set_snap_positions_x_range(to_unsafe, first.to_f64, interval.to_f64)
      self
    end

    def set_snap_positions_y(positions : Enumerable(Number)) : self
      values = positions.map(&.to_f64).to_a
      LibQt6.qt6cr_scroller_set_snap_positions_y_list(to_unsafe, values.to_unsafe, values.size.to_i32)
      self
    end

    def set_snap_positions_y(first : Number, interval : Number) : self
      LibQt6.qt6cr_scroller_set_snap_positions_y_range(to_unsafe, first.to_f64, interval.to_f64)
      self
    end

    def scroll_to(position : PointF, scroll_time : Int? = nil) : self
      if value = scroll_time
        LibQt6.qt6cr_scroller_scroll_to_with_time(to_unsafe, position.to_native, value.to_i32)
      else
        LibQt6.qt6cr_scroller_scroll_to(to_unsafe, position.to_native)
      end
      self
    end

    def ensure_visible(rect : RectF, x_margin : Number, y_margin : Number, scroll_time : Int? = nil) : self
      if value = scroll_time
        LibQt6.qt6cr_scroller_ensure_visible_with_time(to_unsafe, rect.to_native, x_margin.to_f64, y_margin.to_f64, value.to_i32)
      else
        LibQt6.qt6cr_scroller_ensure_visible(to_unsafe, rect.to_native, x_margin.to_f64, y_margin.to_f64)
      end
      self
    end

    def resend_prepare_event : self
      LibQt6.qt6cr_scroller_resend_prepare_event(to_unsafe)
      self
    end

    def on_state_changed(&block : ScrollerState ->) : self
      @state_changed.connect { |value| block.call(value) }
      self
    end

    def on_scroller_properties_changed(&block : ScrollerProperties ->) : self
      @scroller_properties_changed.connect { |value| block.call(value) }
      self
    end

    def set_scroller_properties(value : ScrollerProperties) : self
      self.scroller_properties = value
      self
    end

    protected def emit_state_changed(value : Int32) : Nil
      @state_changed.emit(ScrollerState.from_value(value))
    end

    protected def emit_scroller_properties_changed(handle : LibQt6::Handle) : Nil
      @scroller_properties_changed.emit(ScrollerProperties.wrap(handle, true))
    end

    private def register_callbacks : Nil
      @state_changed = Signal(ScrollerState).new
      @scroller_properties_changed = Signal(ScrollerProperties).new
      @state_changed_userdata = Box.box(self)
      @scroller_properties_changed_userdata = Box.box(self)
      LibQt6.qt6cr_scroller_on_state_changed(to_unsafe, STATE_CHANGED_TRAMPOLINE, @state_changed_userdata)
      LibQt6.qt6cr_scroller_on_scroller_properties_changed(to_unsafe, PROPERTIES_CHANGED_TRAMPOLINE, @scroller_properties_changed_userdata)
    end

    private STATE_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : Int32) do
      Box(Scroller).unbox(userdata).emit_state_changed(value)
    end

    private PROPERTIES_CHANGED_TRAMPOLINE = ->(userdata : Void*, handle : Void*) do
      Box(Scroller).unbox(userdata).emit_scroller_properties_changed(handle)
    end
  end
end
