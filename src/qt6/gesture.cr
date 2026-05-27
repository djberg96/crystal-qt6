module Qt6
  # Wraps `QGesture`.
  class Gesture < QObject
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : Gesture
      case LibQt6.qt6cr_gesture_type(handle)
      when GestureType::PanGesture.value
        PanGesture.wrap(handle, owned)
      when GestureType::PinchGesture.value
        PinchGesture.wrap(handle, owned)
      when GestureType::SwipeGesture.value
        SwipeGesture.wrap(handle, owned)
      else
        new(handle, owned)
      end
    end

    # Creates a gesture with an optional parent object.
    def initialize(parent : QObject? = nil)
      super(LibQt6.qt6cr_gesture_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the raw Qt gesture type integer, including dynamically registered custom types.
    def gesture_type_value : Int32
      LibQt6.qt6cr_gesture_type(to_unsafe)
    end

    # Returns the gesture's Qt-recognized type.
    def gesture_type : GestureType
      GestureType.values.find(&.value.==(gesture_type_value)) || GestureType::CustomGesture
    end

    # Returns the current gesture state.
    def state : GestureState
      GestureState.from_value(LibQt6.qt6cr_gesture_state(to_unsafe))
    end

    # Returns the current gesture cancel policy.
    def gesture_cancel_policy : GestureCancelPolicy
      GestureCancelPolicy.from_value(LibQt6.qt6cr_gesture_cancel_policy(to_unsafe))
    end

    # Sets the gesture cancel policy and returns it.
    def gesture_cancel_policy=(value : GestureCancelPolicy) : GestureCancelPolicy
      LibQt6.qt6cr_gesture_set_cancel_policy(to_unsafe, value.value)
      value
    end

    # Returns the current gesture hot spot.
    def hot_spot : PointF
      PointF.from_native(LibQt6.qt6cr_gesture_hot_spot(to_unsafe))
    end

    # Sets the gesture hot spot and returns it.
    def hot_spot=(value : PointF) : PointF
      LibQt6.qt6cr_gesture_set_hot_spot(to_unsafe, value.to_native)
      value
    end

    # Returns `true` when a hot spot is currently set.
    def has_hot_spot? : Bool
      LibQt6.qt6cr_gesture_has_hot_spot(to_unsafe)
    end

    # Clears the currently configured hot spot.
    def unset_hot_spot : self
      LibQt6.qt6cr_gesture_unset_hot_spot(to_unsafe)
      self
    end

    # Qt-style alias for `gesture_cancel_policy=`.
    def set_gesture_cancel_policy(value : GestureCancelPolicy) : self
      self.gesture_cancel_policy = value
      self
    end

    # Qt-style alias for `hot_spot=`.
    def set_hot_spot(value : PointF) : self
      self.hot_spot = value
      self
    end
  end
end
