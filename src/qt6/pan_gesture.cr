module Qt6
  # Wraps `QPanGesture`.
  class PanGesture < Gesture
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a pan gesture with an optional parent object.
    def initialize(parent : QObject? = nil)
      super(LibQt6.qt6cr_pan_gesture_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the current pan offset.
    def offset : PointF
      PointF.from_native(LibQt6.qt6cr_pan_gesture_offset(to_unsafe))
    end

    # Sets the current pan offset and returns it.
    def offset=(value : PointF) : PointF
      LibQt6.qt6cr_pan_gesture_set_offset(to_unsafe, value.to_native)
      value
    end

    # Returns the previous pan offset.
    def last_offset : PointF
      PointF.from_native(LibQt6.qt6cr_pan_gesture_last_offset(to_unsafe))
    end

    # Sets the previous pan offset and returns it.
    def last_offset=(value : PointF) : PointF
      LibQt6.qt6cr_pan_gesture_set_last_offset(to_unsafe, value.to_native)
      value
    end

    # Returns the delta between the current and previous offsets.
    def delta : PointF
      PointF.from_native(LibQt6.qt6cr_pan_gesture_delta(to_unsafe))
    end

    # Returns the gesture acceleration multiplier.
    def acceleration : Float64
      LibQt6.qt6cr_pan_gesture_acceleration(to_unsafe)
    end

    # Sets the gesture acceleration multiplier and returns it.
    def acceleration=(value : Number) : Float64
      LibQt6.qt6cr_pan_gesture_set_acceleration(to_unsafe, value.to_f64)
      value.to_f64
    end

    # Qt-style alias for `offset=`.
    def set_offset(value : PointF) : self
      self.offset = value
      self
    end

    # Qt-style alias for `last_offset=`.
    def set_last_offset(value : PointF) : self
      self.last_offset = value
      self
    end

    # Qt-style alias for `acceleration=`.
    def set_acceleration(value : Number) : self
      self.acceleration = value
      self
    end
  end
end
