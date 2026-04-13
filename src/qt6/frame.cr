module Qt6
  # Wraps `QFrame`.
  class Frame < Widget
    # Creates a frame with an optional parent.
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_frame_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the current frame shape.
    def frame_shape : FrameShape
      FrameShape.from_value(LibQt6.qt6cr_frame_shape(to_unsafe))
    end

    # Sets the frame shape and returns it.
    def frame_shape=(value : FrameShape) : FrameShape
      LibQt6.qt6cr_frame_set_shape(to_unsafe, value.value)
      value
    end

    # Returns the current frame shadow.
    def frame_shadow : FrameShadow
      FrameShadow.from_value(LibQt6.qt6cr_frame_shadow(to_unsafe))
    end

    # Sets the frame shadow and returns it.
    def frame_shadow=(value : FrameShadow) : FrameShadow
      LibQt6.qt6cr_frame_set_shadow(to_unsafe, value.value)
      value
    end
  end
end
