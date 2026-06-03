module Qt6
  # Wraps `QParallelAnimationGroup`.
  class ParallelAnimationGroup < AnimationGroup
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(parent : QObject? = nil)
      super(LibQt6.qt6cr_parallel_animation_group_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end
  end
end
