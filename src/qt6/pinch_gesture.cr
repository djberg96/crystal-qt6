module Qt6
  # Wraps `QPinchGesture`.
  class PinchGesture < Gesture
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a pinch gesture with an optional parent object.
    def initialize(parent : QObject? = nil)
      super(LibQt6.qt6cr_pinch_gesture_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the current change flags.
    def change_flags : PinchGestureChangeFlag
      PinchGestureChangeFlag.from_value(LibQt6.qt6cr_pinch_gesture_change_flags(to_unsafe))
    end

    # Sets the current change flags and returns them.
    def change_flags=(value : PinchGestureChangeFlag) : PinchGestureChangeFlag
      LibQt6.qt6cr_pinch_gesture_set_change_flags(to_unsafe, value.value)
      value
    end

    # Returns the accumulated change flags.
    def total_change_flags : PinchGestureChangeFlag
      PinchGestureChangeFlag.from_value(LibQt6.qt6cr_pinch_gesture_total_change_flags(to_unsafe))
    end

    # Sets the accumulated change flags and returns them.
    def total_change_flags=(value : PinchGestureChangeFlag) : PinchGestureChangeFlag
      LibQt6.qt6cr_pinch_gesture_set_total_change_flags(to_unsafe, value.value)
      value
    end

    # Returns the center point where the pinch started.
    def start_center_point : PointF
      PointF.from_native(LibQt6.qt6cr_pinch_gesture_start_center_point(to_unsafe))
    end

    # Sets the center point where the pinch started and returns it.
    def start_center_point=(value : PointF) : PointF
      LibQt6.qt6cr_pinch_gesture_set_start_center_point(to_unsafe, value.to_native)
      value
    end

    # Returns the previous center point.
    def last_center_point : PointF
      PointF.from_native(LibQt6.qt6cr_pinch_gesture_last_center_point(to_unsafe))
    end

    # Sets the previous center point and returns it.
    def last_center_point=(value : PointF) : PointF
      LibQt6.qt6cr_pinch_gesture_set_last_center_point(to_unsafe, value.to_native)
      value
    end

    # Returns the current center point.
    def center_point : PointF
      PointF.from_native(LibQt6.qt6cr_pinch_gesture_center_point(to_unsafe))
    end

    # Sets the current center point and returns it.
    def center_point=(value : PointF) : PointF
      LibQt6.qt6cr_pinch_gesture_set_center_point(to_unsafe, value.to_native)
      value
    end

    # Returns the accumulated scale factor.
    def total_scale_factor : Float64
      LibQt6.qt6cr_pinch_gesture_total_scale_factor(to_unsafe)
    end

    # Sets the accumulated scale factor and returns it.
    def total_scale_factor=(value : Number) : Float64
      LibQt6.qt6cr_pinch_gesture_set_total_scale_factor(to_unsafe, value.to_f64)
      value.to_f64
    end

    # Returns the previous scale factor.
    def last_scale_factor : Float64
      LibQt6.qt6cr_pinch_gesture_last_scale_factor(to_unsafe)
    end

    # Sets the previous scale factor and returns it.
    def last_scale_factor=(value : Number) : Float64
      LibQt6.qt6cr_pinch_gesture_set_last_scale_factor(to_unsafe, value.to_f64)
      value.to_f64
    end

    # Returns the current scale factor.
    def scale_factor : Float64
      LibQt6.qt6cr_pinch_gesture_scale_factor(to_unsafe)
    end

    # Sets the current scale factor and returns it.
    def scale_factor=(value : Number) : Float64
      LibQt6.qt6cr_pinch_gesture_set_scale_factor(to_unsafe, value.to_f64)
      value.to_f64
    end

    # Returns the accumulated rotation angle.
    def total_rotation_angle : Float64
      LibQt6.qt6cr_pinch_gesture_total_rotation_angle(to_unsafe)
    end

    # Sets the accumulated rotation angle and returns it.
    def total_rotation_angle=(value : Number) : Float64
      LibQt6.qt6cr_pinch_gesture_set_total_rotation_angle(to_unsafe, value.to_f64)
      value.to_f64
    end

    # Returns the previous rotation angle.
    def last_rotation_angle : Float64
      LibQt6.qt6cr_pinch_gesture_last_rotation_angle(to_unsafe)
    end

    # Sets the previous rotation angle and returns it.
    def last_rotation_angle=(value : Number) : Float64
      LibQt6.qt6cr_pinch_gesture_set_last_rotation_angle(to_unsafe, value.to_f64)
      value.to_f64
    end

    # Returns the current rotation angle.
    def rotation_angle : Float64
      LibQt6.qt6cr_pinch_gesture_rotation_angle(to_unsafe)
    end

    # Sets the current rotation angle and returns it.
    def rotation_angle=(value : Number) : Float64
      LibQt6.qt6cr_pinch_gesture_set_rotation_angle(to_unsafe, value.to_f64)
      value.to_f64
    end

    # Qt-style alias for `change_flags=`.
    def set_change_flags(value : PinchGestureChangeFlag) : self
      self.change_flags = value
      self
    end

    # Qt-style alias for `total_change_flags=`.
    def set_total_change_flags(value : PinchGestureChangeFlag) : self
      self.total_change_flags = value
      self
    end

    # Qt-style alias for `start_center_point=`.
    def set_start_center_point(value : PointF) : self
      self.start_center_point = value
      self
    end

    # Qt-style alias for `last_center_point=`.
    def set_last_center_point(value : PointF) : self
      self.last_center_point = value
      self
    end

    # Qt-style alias for `center_point=`.
    def set_center_point(value : PointF) : self
      self.center_point = value
      self
    end

    # Qt-style alias for `total_scale_factor=`.
    def set_total_scale_factor(value : Number) : self
      self.total_scale_factor = value
      self
    end

    # Qt-style alias for `last_scale_factor=`.
    def set_last_scale_factor(value : Number) : self
      self.last_scale_factor = value
      self
    end

    # Qt-style alias for `scale_factor=`.
    def set_scale_factor(value : Number) : self
      self.scale_factor = value
      self
    end

    # Qt-style alias for `total_rotation_angle=`.
    def set_total_rotation_angle(value : Number) : self
      self.total_rotation_angle = value
      self
    end

    # Qt-style alias for `last_rotation_angle=`.
    def set_last_rotation_angle(value : Number) : self
      self.last_rotation_angle = value
      self
    end

    # Qt-style alias for `rotation_angle=`.
    def set_rotation_angle(value : Number) : self
      self.rotation_angle = value
      self
    end
  end
end
