module Qt6
  # Wraps `QTapAndHoldGesture`.
  class TapAndHoldGesture < Gesture
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Returns the process-wide tap-and-hold timeout in milliseconds.
    def self.timeout : Int32
      LibQt6.qt6cr_tap_and_hold_gesture_timeout
    end

    # Sets the process-wide tap-and-hold timeout in milliseconds and returns it.
    def self.timeout=(value : Int) : Int32
      timeout = value.to_i
      LibQt6.qt6cr_tap_and_hold_gesture_set_timeout(timeout)
      timeout
    end

    # Qt-style alias for `timeout=`.
    def self.set_timeout(value : Int) : self.class
      self.timeout = value
      self
    end

    # Creates a tap-and-hold gesture with an optional parent object.
    def initialize(parent : QObject? = nil)
      super(LibQt6.qt6cr_tap_and_hold_gesture_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the gesture's held position.
    def position : PointF
      PointF.from_native(LibQt6.qt6cr_tap_and_hold_gesture_position(to_unsafe))
    end

    # Sets the gesture's held position and returns it.
    def position=(value : PointF) : PointF
      LibQt6.qt6cr_tap_and_hold_gesture_set_position(to_unsafe, value.to_native)
      value
    end

    # Qt-style alias for `position=`.
    def set_position(value : PointF) : self
      self.position = value
      self
    end
  end
end
