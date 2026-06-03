module Qt6
  # Wraps `QPauseAnimation`.
  class PauseAnimation < AbstractAnimation
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(parent : QObject? = nil)
      super(LibQt6.qt6cr_pause_animation_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    def initialize(duration : Int, parent : QObject? = nil)
      super(LibQt6.qt6cr_pause_animation_create_with_duration(duration.to_i32, parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def duration=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_pause_animation_set_duration(to_unsafe, int_value)
      int_value
    end

    def set_duration(value : Int) : self
      self.duration = value
      self
    end
  end
end
