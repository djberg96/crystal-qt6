module Qt6
  # Wraps `QFrame`.
  class Frame < Widget
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

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

    # Returns the combined frame shape/shadow style mask.
    def frame_style : Int32
      LibQt6.qt6cr_frame_style(to_unsafe)
    end

    # Sets the combined frame shape/shadow style mask and returns it.
    def frame_style=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_frame_set_style(to_unsafe, int_value)
      int_value
    end

    # Returns the outer line width used by the frame.
    def line_width : Int32
      LibQt6.qt6cr_frame_line_width(to_unsafe)
    end

    # Sets the outer line width and returns it.
    def line_width=(value : Int) : Int32
      LibQt6.qt6cr_frame_set_line_width(to_unsafe, value)
      value.to_i32
    end

    # Returns the mid-line width used by boxed and panel styles.
    def mid_line_width : Int32
      LibQt6.qt6cr_frame_mid_line_width(to_unsafe)
    end

    # Sets the mid-line width and returns it.
    def mid_line_width=(value : Int) : Int32
      LibQt6.qt6cr_frame_set_mid_line_width(to_unsafe, value)
      value.to_i32
    end

    # Returns the effective frame width computed by Qt.
    def frame_width : Int32
      LibQt6.qt6cr_frame_frame_width(to_unsafe)
    end

    # Returns the frame rectangle used to draw the border.
    def frame_rect : Rect
      Rect.from_native(LibQt6.qt6cr_frame_frame_rect(to_unsafe))
    end

    # Sets the frame rectangle and returns it.
    def frame_rect=(value : Rect) : Rect
      LibQt6.qt6cr_frame_set_frame_rect(to_unsafe, value.to_native)
      value
    end

    # Qt-style alias for `frame_shape=`.
    def set_frame_shape(value : FrameShape) : self
      self.frame_shape = value
      self
    end

    # Qt-style alias for `frame_shadow=`.
    def set_frame_shadow(value : FrameShadow) : self
      self.frame_shadow = value
      self
    end

    # Qt-style alias for `frame_style=`.
    def set_frame_style(value : Int) : self
      self.frame_style = value
      self
    end

    # Convenience overload for combined shape/shadow styles.
    def set_frame_style(shape : FrameShape, shadow : FrameShadow) : self
      self.frame_style = shape.value | shadow.value
      self
    end

    # Qt-style alias for `line_width=`.
    def set_line_width(value : Int) : self
      self.line_width = value
      self
    end

    # Qt-style alias for `mid_line_width=`.
    def set_mid_line_width(value : Int) : self
      self.mid_line_width = value
      self
    end

    # Qt-style alias for `frame_rect=`.
    def set_frame_rect(value : Rect) : self
      self.frame_rect = value
      self
    end
  end
end
