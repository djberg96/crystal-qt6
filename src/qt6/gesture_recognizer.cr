module Qt6
  # Wraps a callback-backed `QGestureRecognizer`.
  class GestureRecognizer < NativeResource
    @create_callback : Proc(QObject?, Gesture)? = nil
    @recognize_callback : Proc(Gesture, QObject?, QEvent, GestureRecognizerResult)? = nil
    @reset_callback : Proc(Gesture, Nil)? = nil
    @callback_userdata : LibQt6::Handle = Pointer(Void).null
    @registered_types = [] of Int32

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize
      super(LibQt6.qt6cr_gesture_recognizer_create)
      register_callbacks
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      register_callbacks
    end

    # Registers a block that can create the gesture instance for a target.
    #
    # Qt may pass `nil` here while probing the recognizer during registration,
    # so callbacks should not assume a watched object is always present.
    def on_create(&block : QObject? -> Gesture) : self
      @create_callback = block
      self
    end

    # Registers a block that decides how the recognizer responds to an event.
    def on_recognize(&block : Gesture, QObject?, QEvent -> GestureRecognizerResult) : self
      @recognize_callback = block
      self
    end

    # Registers a block to run when Qt resets a gesture state object.
    def on_reset(&block : Gesture ->) : self
      @reset_callback = block
      self
    end

    # Creates a gesture for the optional target using this recognizer.
    def create(target : QObject? = nil) : Gesture
      Gesture.wrap(LibQt6.qt6cr_gesture_recognizer_create_gesture(to_unsafe, target.try(&.to_unsafe) || Pointer(Void).null))
    end

    # Runs the recognizer against the given gesture state, watched object, and event.
    def recognize(state : Gesture, watched : QObject?, event : QEvent) : GestureRecognizerResult
      GestureRecognizerResult.from_value(
        LibQt6.qt6cr_gesture_recognizer_recognize(
          to_unsafe,
          state.to_unsafe,
          watched.try(&.to_unsafe) || Pointer(Void).null,
          event.to_unsafe
        )
      )
    end

    # Resets the given gesture state using this recognizer.
    def reset(state : Gesture) : self
      LibQt6.qt6cr_gesture_recognizer_reset_gesture(to_unsafe, state.to_unsafe)
      self
    end

    # Registers this recognizer with Qt and returns the raw custom gesture type id.
    #
    # This type id is what widgets grab and what Qt uses during live gesture
    # delivery. Standalone `Gesture` instances returned by `create` still report
    # their own native type, which for plain `Gesture.new` remains
    # `GestureType::CustomGesture`.
    def register : Int32
      type = LibQt6.qt6cr_gesture_recognizer_register(to_unsafe)
      @registered_types << type unless @registered_types.includes?(type)
      adopt_by_owner!
      type
    end

    # Unregisters a previously registered gesture type.
    def unregister(type : Int) : self
      type_value = type.to_i32
      LibQt6.qt6cr_gesture_recognizer_unregister(type_value)
      @registered_types.delete(type_value)
      mark_destroyed
      self
    end

    # Returns the currently registered raw gesture type ids for this recognizer.
    def registered_types : Array(Int32)
      @registered_types.dup
    end

    protected def create_gesture(target_handle : LibQt6::Handle) : LibQt6::Handle
      target = target_handle.null? ? nil : QObject.wrap(target_handle)
      gesture = @create_callback.try(&.call(target)) || Gesture.new(target)
      gesture.to_unsafe
    end

    protected def recognize_gesture(state_handle : LibQt6::Handle, watched_handle : LibQt6::Handle, event_handle : LibQt6::Handle) : Int32
      callback = @recognize_callback
      return GestureRecognizerResult::Ignore.value unless callback

      state = Gesture.wrap(state_handle)
      watched = watched_handle.null? ? nil : QObject.wrap(watched_handle)
      callback.call(state, watched, QEvent.new(event_handle)).value
    end

    protected def reset_gesture(state_handle : LibQt6::Handle) : Nil
      callback = @reset_callback
      return unless callback

      callback.call(Gesture.wrap(state_handle))
    end

    protected def destroy_native : Nil
      @registered_types.each do |type|
        LibQt6.qt6cr_gesture_recognizer_unregister(type)
      end
      @registered_types.clear
      LibQt6.qt6cr_gesture_recognizer_destroy(to_unsafe)
    end

    private def register_callbacks : Nil
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_gesture_recognizer_on_create(to_unsafe, CREATE_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_gesture_recognizer_on_recognize(to_unsafe, RECOGNIZE_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_gesture_recognizer_on_reset(to_unsafe, RESET_TRAMPOLINE, @callback_userdata)
    end

    private CREATE_TRAMPOLINE = ->(userdata : Void*, target_handle : Void*) do
      Box(GestureRecognizer).unbox(userdata).create_gesture(target_handle)
    end

    private RECOGNIZE_TRAMPOLINE = ->(userdata : Void*, state_handle : Void*, watched_handle : Void*, event_handle : Void*) do
      Box(GestureRecognizer).unbox(userdata).recognize_gesture(state_handle, watched_handle, event_handle)
    end

    private RESET_TRAMPOLINE = ->(userdata : Void*, state_handle : Void*) do
      Box(GestureRecognizer).unbox(userdata).reset_gesture(state_handle)
    end
  end
end
