module Qt6
  # Wraps `QStyleOptionFrame` for framed widget paint and layout state.
  class StyleOptionFrame < StyleOption
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize
      super(LibQt6.qt6cr_style_option_frame_create, true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def line_width : Int32
      LibQt6.qt6cr_style_option_frame_line_width(to_unsafe)
    end

    def line_width=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_style_option_frame_set_line_width(to_unsafe, int_value)
      int_value
    end

    def mid_line_width : Int32
      LibQt6.qt6cr_style_option_frame_mid_line_width(to_unsafe)
    end

    def mid_line_width=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_style_option_frame_set_mid_line_width(to_unsafe, int_value)
      int_value
    end

    def features : StyleOptionFrameFeature
      StyleOptionFrameFeature.from_value(LibQt6.qt6cr_style_option_frame_features(to_unsafe))
    end

    def features=(value : StyleOptionFrameFeature) : StyleOptionFrameFeature
      LibQt6.qt6cr_style_option_frame_set_features(to_unsafe, value.value)
      value
    end

    def frame_shape : FrameShape
      FrameShape.from_value(LibQt6.qt6cr_style_option_frame_shape(to_unsafe))
    end

    def frame_shape=(value : FrameShape) : FrameShape
      LibQt6.qt6cr_style_option_frame_set_shape(to_unsafe, value.value)
      value
    end

    def init_from(frame : Frame) : self
      LibQt6.qt6cr_style_option_init_from(to_unsafe, frame.to_unsafe)
      LibQt6.qt6cr_frame_init_style_option(frame.to_unsafe, to_unsafe)
      self
    end

    def init_from(line_edit : LineEdit) : self
      LibQt6.qt6cr_style_option_init_from(to_unsafe, line_edit.to_unsafe)
      LibQt6.qt6cr_line_edit_init_style_option(line_edit.to_unsafe, to_unsafe)
      self
    end

    def set_line_width(value : Int) : self
      self.line_width = value
      self
    end

    def set_mid_line_width(value : Int) : self
      self.mid_line_width = value
      self
    end

    def set_features(value : StyleOptionFrameFeature) : self
      self.features = value
      self
    end

    def set_frame_shape(value : FrameShape) : self
      self.frame_shape = value
      self
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_style_option_frame_destroy(to_unsafe)
    end
  end
end
