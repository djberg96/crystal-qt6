module Qt6
  # Wraps `QGestureEvent` for direct inspection of delivered or synthesized gestures.
  class GestureEvent < NativeResource
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a gesture event for the provided gestures.
    def initialize(gestures : Enumerable(Gesture))
      handles = gestures.to_a.map(&.to_unsafe)
      super(
        LibQt6.qt6cr_gesture_event_create(
          handles.empty? ? Pointer(LibQt6::Handle).null : handles.to_unsafe,
          handles.size
        )
      )
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the raw Qt event type integer.
    def type_value : Int32
      LibQt6.qt6cr_event_type(to_unsafe)
    end

    # Returns the Qt event type when it maps to a known enum value.
    def type : EventType?
      EventType.values.find { |value| value.value == type_value }
    end

    # Marks the whole event as accepted.
    def accept : self
      LibQt6.qt6cr_event_accept(to_unsafe)
      self
    end

    # Marks the whole event as ignored.
    def ignore : self
      LibQt6.qt6cr_event_ignore(to_unsafe)
      self
    end

    # Returns whether the whole event is currently accepted.
    def accepted? : Bool
      LibQt6.qt6cr_event_is_accepted(to_unsafe)
    end

    # Returns all gestures carried by the event.
    def gestures : Array(Gesture)
      Qt6.copy_and_release_handles(LibQt6.qt6cr_gesture_event_gestures(to_unsafe)).map do |handle|
        Gesture.wrap(handle)
      end
    end

    # Returns the gesture matching the given type, if present.
    def gesture(type : GestureType) : Gesture?
      gesture(type.value)
    end

    # Returns the gesture matching the given raw type id, if present.
    def gesture(type : Int) : Gesture?
      handle = LibQt6.qt6cr_gesture_event_gesture(to_unsafe, type.to_i32)
      handle.null? ? nil : Gesture.wrap(handle)
    end

    # Returns the gestures Qt considers active in this event.
    def active_gestures : Array(Gesture)
      Qt6.copy_and_release_handles(LibQt6.qt6cr_gesture_event_active_gestures(to_unsafe)).map do |handle|
        Gesture.wrap(handle)
      end
    end

    # Returns the gestures Qt considers canceled in this event.
    def canceled_gestures : Array(Gesture)
      Qt6.copy_and_release_handles(LibQt6.qt6cr_gesture_event_canceled_gestures(to_unsafe)).map do |handle|
        Gesture.wrap(handle)
      end
    end

    # Sets the accepted state for a specific gesture.
    def set_accepted(gesture : Gesture, accepted : Bool) : self
      LibQt6.qt6cr_gesture_event_set_accepted_gesture(to_unsafe, gesture.to_unsafe, accepted)
      self
    end

    # Marks a specific gesture as accepted.
    def accept(gesture : Gesture) : self
      LibQt6.qt6cr_gesture_event_accept_gesture(to_unsafe, gesture.to_unsafe)
      self
    end

    # Marks a specific gesture as ignored.
    def ignore(gesture : Gesture) : self
      LibQt6.qt6cr_gesture_event_ignore_gesture(to_unsafe, gesture.to_unsafe)
      self
    end

    # Returns whether a specific gesture is currently accepted.
    def accepted?(gesture : Gesture) : Bool
      LibQt6.qt6cr_gesture_event_is_accepted_gesture(to_unsafe, gesture.to_unsafe)
    end

    # Sets the accepted state for a whole gesture type.
    def set_accepted(type : GestureType, accepted : Bool) : self
      set_accepted(type.value, accepted)
      self
    end

    # Sets the accepted state for a whole raw gesture type id.
    def set_accepted(type : Int, accepted : Bool) : self
      LibQt6.qt6cr_gesture_event_set_accepted_type(to_unsafe, type.to_i32, accepted)
      self
    end

    # Marks the given gesture type as accepted.
    def accept(type : GestureType) : self
      accept(type.value)
      self
    end

    # Marks the given raw gesture type id as accepted.
    def accept(type : Int) : self
      LibQt6.qt6cr_gesture_event_accept_type(to_unsafe, type.to_i32)
      self
    end

    # Marks the given gesture type as ignored.
    def ignore(type : GestureType) : self
      ignore(type.value)
      self
    end

    # Marks the given raw gesture type id as ignored.
    def ignore(type : Int) : self
      LibQt6.qt6cr_gesture_event_ignore_type(to_unsafe, type.to_i32)
      self
    end

    # Returns whether the given gesture type is currently accepted.
    def accepted?(type : GestureType) : Bool
      accepted?(type.value)
    end

    # Returns whether the given raw gesture type id is currently accepted.
    def accepted?(type : Int) : Bool
      LibQt6.qt6cr_gesture_event_is_accepted_type(to_unsafe, type.to_i32)
    end

    # Returns the widget currently associated with the event, if any.
    def widget : Widget?
      handle = LibQt6.qt6cr_gesture_event_widget(to_unsafe)
      handle.null? ? nil : Widget.wrap(handle)
    end

    # Associates the event with a widget and returns the assigned widget.
    def widget=(value : Widget?) : Widget?
      LibQt6.qt6cr_gesture_event_set_widget(to_unsafe, value.try(&.to_unsafe) || Pointer(Void).null)
      value
    end

    # Qt-style alias for `widget=`.
    def set_widget(value : Widget?) : self
      self.widget = value
      self
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_gesture_event_destroy(to_unsafe)
    end
  end
end
