module Qt6
  # Shared wrapper for `QAnimationGroup` instances.
  class AnimationGroup < AbstractAnimation
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def animation_at(index : Int) : AbstractAnimation?
      handle = LibQt6.qt6cr_animation_group_animation_at(to_unsafe, index.to_i32)
      handle.null? ? nil : AbstractAnimation.wrap(handle)
    end

    def count : Int32
      LibQt6.qt6cr_animation_group_animation_count(to_unsafe)
    end

    def animation_count : Int32
      count
    end

    def index_of(animation : AbstractAnimation) : Int32
      LibQt6.qt6cr_animation_group_index_of_animation(to_unsafe, animation.to_unsafe)
    end

    def add_animation(animation : AbstractAnimation) : AbstractAnimation
      LibQt6.qt6cr_animation_group_add_animation(to_unsafe, animation.to_unsafe)
      animation.adopt_by_parent!
      animation
    end

    def insert_animation(index : Int, animation : AbstractAnimation) : AbstractAnimation
      LibQt6.qt6cr_animation_group_insert_animation(to_unsafe, index.to_i32, animation.to_unsafe)
      animation.adopt_by_parent!
      animation
    end

    def remove_animation(animation : AbstractAnimation) : AbstractAnimation
      LibQt6.qt6cr_animation_group_remove_animation(to_unsafe, animation.to_unsafe)
      animation.assume_ownership!
      animation
    end

    def take_animation(index : Int) : AbstractAnimation?
      handle = LibQt6.qt6cr_animation_group_take_animation(to_unsafe, index.to_i32)
      handle.null? ? nil : AbstractAnimation.wrap(handle, true)
    end

    def clear : self
      LibQt6.qt6cr_animation_group_clear(to_unsafe)
      self
    end

    def <<(animation : AbstractAnimation) : self
      add_animation(animation)
      self
    end
  end
end
