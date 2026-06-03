module Qt6
  # Wraps `QSequentialAnimationGroup`.
  class SequentialAnimationGroup < AnimationGroup
    @current_animation_changed : Signal(AbstractAnimation?) = Signal(AbstractAnimation?).new
    @sequential_callback_userdata : LibQt6::Handle = Pointer(Void).null

    getter current_animation_changed : Signal(AbstractAnimation?)

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(parent : QObject? = nil)
      super(LibQt6.qt6cr_sequential_animation_group_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      register_sequential_callbacks
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      register_sequential_callbacks
    end

    def add_pause(duration : Int) : PauseAnimation
      PauseAnimation.wrap(LibQt6.qt6cr_sequential_animation_group_add_pause(to_unsafe, duration.to_i32))
    end

    def insert_pause(index : Int, duration : Int) : PauseAnimation
      PauseAnimation.wrap(LibQt6.qt6cr_sequential_animation_group_insert_pause(to_unsafe, index.to_i32, duration.to_i32))
    end

    def current_animation : AbstractAnimation?
      handle = LibQt6.qt6cr_sequential_animation_group_current_animation(to_unsafe)
      handle.null? ? nil : AbstractAnimation.wrap(handle)
    end

    def on_current_animation_changed(&block : AbstractAnimation? ->) : self
      @current_animation_changed.connect { |animation| block.call(animation) }
      self
    end

    private def register_sequential_callbacks : Nil
      @current_animation_changed = Signal(AbstractAnimation?).new
      @sequential_callback_userdata = Box.box(self.as(SequentialAnimationGroup))
      LibQt6.qt6cr_sequential_animation_group_on_current_animation_changed(to_unsafe, CURRENT_ANIMATION_CHANGED_TRAMPOLINE, @sequential_callback_userdata)
    end

    protected def emit_current_animation_changed(handle : LibQt6::Handle) : Nil
      @current_animation_changed.emit(handle.null? ? nil : AbstractAnimation.wrap(handle))
    end

    private CURRENT_ANIMATION_CHANGED_TRAMPOLINE = ->(userdata : Void*, handle : Void*) do
      Box(SequentialAnimationGroup).unbox(userdata).emit_current_animation_changed(handle)
    end
  end
end
