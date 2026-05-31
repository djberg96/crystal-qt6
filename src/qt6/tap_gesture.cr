module Qt6
  # Wraps `QTapGesture`.
  class TapGesture < Gesture
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a tap gesture with an optional parent object.
    def initialize(parent : QObject? = nil)
      super(LibQt6.qt6cr_tap_gesture_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the gesture's tap position.
    def position : PointF
      PointF.from_native(LibQt6.qt6cr_tap_gesture_position(to_unsafe))
    end

    # Sets the gesture's tap position and returns it.
    def position=(value : PointF) : PointF
      LibQt6.qt6cr_tap_gesture_set_position(to_unsafe, value.to_native)
      value
    end

    # Qt-style alias for `position=`.
    def set_position(value : PointF) : self
      self.position = value
      self
    end
  end
end
