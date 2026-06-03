module Qt6
  # Shared wrapper for `QAbstractAnimation` instances.
  class AbstractAnimation < QObject
    @finished : Signal() = Signal().new
    @state_changed : Signal(AnimationState, AnimationState) = Signal(AnimationState, AnimationState).new
    @current_loop_changed : Signal(Int32) = Signal(Int32).new
    @direction_changed : Signal(AnimationDirection) = Signal(AnimationDirection).new
    @animation_callback_userdata : LibQt6::Handle = Pointer(Void).null

    getter finished : Signal()
    getter state_changed : Signal(AnimationState, AnimationState)
    getter current_loop_changed : Signal(Int32)
    getter direction_changed : Signal(AnimationDirection)

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      register_animation_callbacks
    end

    def state : AnimationState
      AnimationState.from_value(LibQt6.qt6cr_abstract_animation_state(to_unsafe))
    end

    def group : AnimationGroup?
      handle = LibQt6.qt6cr_abstract_animation_group(to_unsafe)
      handle.null? ? nil : AnimationGroup.wrap(handle)
    end

    def direction : AnimationDirection
      AnimationDirection.from_value(LibQt6.qt6cr_abstract_animation_direction(to_unsafe))
    end

    def direction=(value : AnimationDirection) : AnimationDirection
      LibQt6.qt6cr_abstract_animation_set_direction(to_unsafe, value.value)
      value
    end

    def current_time : Int32
      LibQt6.qt6cr_abstract_animation_current_time(to_unsafe)
    end

    def current_time=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_abstract_animation_set_current_time(to_unsafe, int_value)
      int_value
    end

    def current_loop_time : Int32
      LibQt6.qt6cr_abstract_animation_current_loop_time(to_unsafe)
    end

    def loop_count : Int32
      LibQt6.qt6cr_abstract_animation_loop_count(to_unsafe)
    end

    def loop_count=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_abstract_animation_set_loop_count(to_unsafe, int_value)
      int_value
    end

    def current_loop : Int32
      LibQt6.qt6cr_abstract_animation_current_loop(to_unsafe)
    end

    def duration : Int32
      LibQt6.qt6cr_abstract_animation_duration(to_unsafe)
    end

    def total_duration : Int32
      LibQt6.qt6cr_abstract_animation_total_duration(to_unsafe)
    end

    def start(policy : AnimationDeletionPolicy = AnimationDeletionPolicy::KeepWhenStopped) : self
      LibQt6.qt6cr_abstract_animation_start(to_unsafe, policy.value)
      self
    end

    def pause : self
      LibQt6.qt6cr_abstract_animation_pause(to_unsafe)
      self
    end

    def resume : self
      LibQt6.qt6cr_abstract_animation_resume(to_unsafe)
      self
    end

    def paused=(value : Bool) : Bool
      LibQt6.qt6cr_abstract_animation_set_paused(to_unsafe, value)
      value
    end

    def set_paused(value : Bool) : self
      self.paused = value
      self
    end

    def stop : self
      LibQt6.qt6cr_abstract_animation_stop(to_unsafe)
      self
    end

    def set_current_time(value : Int) : self
      self.current_time = value
      self
    end

    def set_direction(value : AnimationDirection) : self
      self.direction = value
      self
    end

    def set_loop_count(value : Int) : self
      self.loop_count = value
      self
    end

    def on_finished(&block : ->) : self
      @finished.connect { block.call }
      self
    end

    def on_state_changed(&block : AnimationState, AnimationState ->) : self
      @state_changed.connect { |new_state, old_state| block.call(new_state, old_state) }
      self
    end

    def on_current_loop_changed(&block : Int32 ->) : self
      @current_loop_changed.connect { |loop| block.call(loop) }
      self
    end

    def on_direction_changed(&block : AnimationDirection ->) : self
      @direction_changed.connect { |direction| block.call(direction) }
      self
    end

    private def register_animation_callbacks : Nil
      @finished = Signal().new
      @state_changed = Signal(AnimationState, AnimationState).new
      @current_loop_changed = Signal(Int32).new
      @direction_changed = Signal(AnimationDirection).new
      @animation_callback_userdata = Box.box(self.as(AbstractAnimation))
      LibQt6.qt6cr_abstract_animation_on_finished(to_unsafe, FINISHED_TRAMPOLINE, @animation_callback_userdata)
      LibQt6.qt6cr_abstract_animation_on_state_changed(to_unsafe, STATE_CHANGED_TRAMPOLINE, @animation_callback_userdata)
      LibQt6.qt6cr_abstract_animation_on_current_loop_changed(to_unsafe, CURRENT_LOOP_CHANGED_TRAMPOLINE, @animation_callback_userdata)
      LibQt6.qt6cr_abstract_animation_on_direction_changed(to_unsafe, DIRECTION_CHANGED_TRAMPOLINE, @animation_callback_userdata)
    end

    protected def emit_finished : Nil
      @finished.emit
    end

    protected def emit_state_changed(new_state : Int32, old_state : Int32) : Nil
      @state_changed.emit(AnimationState.from_value(new_state), AnimationState.from_value(old_state))
    end

    protected def emit_current_loop_changed(loop : Int32) : Nil
      @current_loop_changed.emit(loop)
    end

    protected def emit_direction_changed(direction : Int32) : Nil
      @direction_changed.emit(AnimationDirection.from_value(direction))
    end

    private FINISHED_TRAMPOLINE = ->(userdata : Void*) do
      Box(AbstractAnimation).unbox(userdata).emit_finished
    end

    private STATE_CHANGED_TRAMPOLINE = ->(userdata : Void*, new_state : Int32, old_state : Int32) do
      Box(AbstractAnimation).unbox(userdata).emit_state_changed(new_state, old_state)
    end

    private CURRENT_LOOP_CHANGED_TRAMPOLINE = ->(userdata : Void*, loop : Int32) do
      Box(AbstractAnimation).unbox(userdata).emit_current_loop_changed(loop)
    end

    private DIRECTION_CHANGED_TRAMPOLINE = ->(userdata : Void*, direction : Int32) do
      Box(AbstractAnimation).unbox(userdata).emit_direction_changed(direction)
    end
  end
end
