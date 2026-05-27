module Qt6
  # Wraps `QSwipeGesture`.
  class SwipeGesture < Gesture
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a swipe gesture with an optional parent object.
    def initialize(parent : QObject? = nil)
      super(LibQt6.qt6cr_swipe_gesture_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the gesture's horizontal swipe direction.
    def horizontal_direction : SwipeGestureDirection
      SwipeGestureDirection.from_value(LibQt6.qt6cr_swipe_gesture_horizontal_direction(to_unsafe))
    end

    # Returns the gesture's vertical swipe direction.
    def vertical_direction : SwipeGestureDirection
      SwipeGestureDirection.from_value(LibQt6.qt6cr_swipe_gesture_vertical_direction(to_unsafe))
    end

    # Returns the gesture's swipe angle in degrees.
    def swipe_angle : Float64
      LibQt6.qt6cr_swipe_gesture_swipe_angle(to_unsafe)
    end

    # Sets the gesture's swipe angle in degrees and returns it.
    def swipe_angle=(value : Number) : Float64
      LibQt6.qt6cr_swipe_gesture_set_swipe_angle(to_unsafe, value.to_f64)
      value.to_f64
    end

    # Qt-style alias for `swipe_angle=`.
    def set_swipe_angle(value : Number) : self
      self.swipe_angle = value
      self
    end
  end
end
